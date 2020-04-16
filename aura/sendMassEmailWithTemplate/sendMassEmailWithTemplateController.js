({
    doInit : function(component, event, helper) {
        helper.getContactData(component);
        helper.getTemplateFolders(component);
    },

    onFolderSelect : function(component, event, helper) {
        component.set("v.selectedFolder", component.find("selectFolder").get("v.value"));
        console.log(component.get("v.selectedFolder"));
        helper.getEmailTemplates(component, event);
    },

    onTemplateSelect : function(component, event, helper) {
        component.set("v.selectedTemplate", component.find("selectTemplate").get("v.value"));
    },

    onClickSend : function(component, event, helper) {
        console.log(component.get("v.selectedTemplate"));
        if(component.get("v.lContactsToEmail") === null) {
            helper.handleNoContactsSelected(component, event);
        } else if(component.get("v.selectedTemplate") === "" || component.get("v.selectedTemplate") === null) {
            helper.handleNoTemplateSelected(component, event);
        }

        if(component.get("v.lContactsToEmail") !== null && component.get("v.lContactsToEmail") !== undefined && component.get("v.selectedTemplate") !== "" && component.get("v.selectedTemplate") !== null && component.get("v.selectedTemplate") !== undefined) {
            helper.sendMassEmail(component, event);
        }
    }
})
