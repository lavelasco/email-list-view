public with sharing class SendEmailWithTemplateController {
    private ApexPages.StandardSetController standardController;

    public String contactApiName {get; set;}
    private List<Id> lIds;
    public List<SObject> lSelectedRecords;
    public List<Id> recipients;
    public List<Contact> contacts {get; set;}
    public String lContacts {get; set;}

    public SendEmailWithTemplateController(ApexPages.StandardSetController standardController) {
        this.standardController = standardController;
        if(!this.standardController.getSelected().isEmpty()) {
            String objectLabel = this.standardController.getSelected()[0].getSObjectType().getDescribe().getLabel();
            String objectName = this.standardController.getSelected()[0].getSObjectType().getDescribe().getName();
            String contactApiName = [SELECT Contact_API_Name__c FROM Contact_API_Mapping__mdt WHERE MasterLabel =: objectLabel].Contact_API_Name__c;
            lIds = new List<Id>();
            for(SObject record : this.standardController.getSelected()) {
                lIds.add(record.Id);
            }
            if(contactApiName != null) {
                String query = 'SELECT Id,' + contactApiName + ' FROM ' + objectName + ' WHERE Id IN :lIds';
                lSelectedRecords = Database.query(query);
            }
            recipients = new List<Id>();
            for(SObject record : lSelectedRecords) {
                recipients.add((Id)record.get(contactApiName));
            }
            contacts = new List<Contact>();
            contacts = [SELECT Id, Name, Email FROM Contact WHERE Id IN :recipients];
            lContacts = JSON.serialize(contacts);
            System.debug('lContacts ser: ' + lContacts);
        }
    }

    @AuraEnabled
    public static List<Contact> displayRecords(List<Map<Object, Object>> contactIds){
        System.debug('called');
        List<String> lIds = new List<String>();
        for(Map<Object, Object> mCon : contactIds) {
            lIds.add((String)mCon.get('Id'));
        }
        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Id IN :lIds];
        System.debug(contacts);
        if(contacts.isEmpty()) {
            return null;
        }
        else {
            return contacts;
        }
    }

    @AuraEnabled
    public static List<Folder> getTemplateFolders(){
        List<Folder> lTemplateFolders = [SELECT Id, Name, Type FROM Folder WHERE Type = 'Email' ORDER BY Name ASC];
        return lTemplateFolders;
    }

    @AuraEnabled
    public static List<EmailTemplate> getEmailTemplates(String folderId){
        List<EmailTemplate> lEmailTemplates = [SELECT Id, Name FROM EmailTemplate WHERE FolderId = :folderId];
        return lEmailTemplates;
    }

    @AuraEnabled
    public static void sendMassEmail(String templateId, List<Contact> contacts){
        if(templateId != null && !contacts.isEmpty()) {
            List<Id> lContactIds = new List<Id>();
            Messaging.MassEmailMessage massEmail = new Messaging.MassEmailMessage();
            for(Contact con : contacts) {
                lContactIds.add(con.Id);
            }
            massEmail.setTargetObjectIds(lContactIds);
            massEmail.setTemplateId(templateId);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.MassEmailMessage[]{massEmail});
        }
    }
}