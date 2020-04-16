# email-list-view
An email button that can be added to a list view for objects that contain a reference to a Contact record
Custom Metadata Type
  Name: Contact API Mapping
  Purpose: stores the contact field API name for each defined object. Referenced by "SendEmailWithTemplateController" to query the 
  contact field based on the object API name in this setting
  Fields:
    Contact API Name: contact field API name on the object
    Master Label: the object API name
