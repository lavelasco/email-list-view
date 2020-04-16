@isTest
public with sharing class SendEmailWithTemplateControllerTest {
    @TestSetup
    static void createData() {
        Account acct = new Account(Name='TestAccount', Program_Status__c = 'Active', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Academic_Program').getRecordTypeId());
        insert acct;
        Contact con =  new Contact(lastName='TestContact', Email='testemail@mailmail.com');
        insert con;
        hed__Term__c term = new hed__Term__c(Name='Test Term', hed__Account__c=acct.Id);
        insert term;
        Id onlineRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('UCF_Online_Connect_Center_Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = acct.Name + ' Opportunity',
                                          StageName = 'Inquiry',
                                          CloseDate = System.today().addMonths(1),
                                          AccountId = acct.Id,
                                          Contact__c = con.Id,
                                          Term__c = term.Id,
                                          Connect_Specialist__c = UserInfo.getUserId(),
                                          Enrollment_Coach__c = UserInfo.getUserId(),
                                          RecordTypeId = onlineRecTypeId);
        insert opp;
    }

    @isTest
    static void testLoadPageAndSendMassMail() {
        List<Opportunity> lOpptys = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lOpptys);
        controller.setSelected(lOpptys);
        SendEmailWithTemplateController emailController = new SendEmailWithTemplateController(controller);
        //Pagereference pageRef = emailController.sendMassEmail();
        Test.stopTest();
    }

    @isTest
    static void testGetTemplateFoldersAndTemplates() {
        Test.startTest();
        List<Folder> templateFolders = SendEmailWithTemplateController.getTemplateFolders();
        List<EmailTemplate> templates = SendEmailWithTemplateController.getEmailTemplates(templateFolders[0].Id);
        Test.stopTest();
    }

    @isTest
    static void testSendMassEmail() {
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<Folder> templateFolders = SendEmailWithTemplateController.getTemplateFolders();
        List<EmailTemplate> templates = SendEmailWithTemplateController.getEmailTemplates(templateFolders[0].Id);
        Test.startTest();
        SendEmailWithTemplateController.sendMassEmail(templates[0].Id, contacts);
    }
}
