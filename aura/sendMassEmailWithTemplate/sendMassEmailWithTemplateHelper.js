({
    getContactData : function(component, event) {
        var getContacts = component.get("c.displayRecords");
        var selected = component.get("v.selectedRecordsFromVF");
        getContacts.setParams({
            "contactIds" : selected
        });
        getContacts.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                //console.log('before: ' + component.get("v.lContactsToEmail"));
                if(response.getReturnValue() === null) {
                    component.set("v.numberOfContacts", 0);
                }
                else {
                    component.set("v.lContactsToEmail", response.getReturnValue());
                    //console.log('after: ' + component.get("v.lContactsToEmail"));
                    component.set("v.numberOfContacts", component.get("v.lContactsToEmail").length);
                }
                
            }
            else {
                console.log("fail");
            }
        });
        $A.enqueueAction(getContacts);
    },

    getTemplateFolders : function(component, event) {
        var getFolders = component.get("c.getTemplateFolders");
        getFolders.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.lTemplateFolders", response.getReturnValue());
            }
            else {
                console.log("fail");
            }
        });
        $A.enqueueAction(getFolders);
    },

    getEmailTemplates : function(component, event) {
        var getTemplates = component.get("c.getEmailTemplates");
        getTemplates.setParams({
            "folderId":component.get("v.selectedFolder")
        });
        getTemplates.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.lEmailTemplates", response.getReturnValue());
            }
            else {
                console.log("fail");
            }
        });
        $A.enqueueAction(getTemplates);
    },

    sendMassEmail : function(component, event) {
        console.log("sending...");
        var sendMassEmailAction = component.get("c.sendMassEmail");
        sendMassEmailAction.setParams({
            "templateId":component.get("v.selectedTemplate"),
            "contacts":component.get("v.lContactsToEmail")
        });
        sendMassEmailAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
            }
            else {
                console.log("fail");
            }
        });
        $A.enqueueAction(sendMassEmailAction);
    },

    handleNoContactsSelected : function(component, event) {
        console.log("no contacts");
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "No contacts selected!",
            "message": "No records were selected. Please return to the list view."
        });
    },

    handleNoTemplateSelected : function(component, event) {
        console.log("no template");
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "No template selected!",
            "message": "Please select an email template."
        });
    },

    redirect: function (){
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }
})
