global with sharing class ContactWebService {
  // Note that this class does not check for empty SOQL queries

  webservice static Integer createContact(String First,
                                          String Last,
                                          String Phone,
                                          Id accountId){
    String [] contactUpdateFields = new String [] {'FirstName',
                                                   'LastName',
                                                   'Phone',
                                                   'AccountId'};
      
    // Obtaining the field name/token map for the Contact object
    Map<String,Schema.SObjectField> m = Schema.SObjectType.Contact.fields.getMap();
    for (String fieldToCheck : contactUpdateFields) {
      // Check if the user has create access on the each field
      if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
        return 1;
      }
    }
    insert new Contact(FirstName = First,
                       LastName  = Last,
                       Phone     = Phone,
                       AccountId = accountId);
    return 0;
        
  }
   
  webservice static String getContactPhone (Id contactId) {
    // Check if the user has read access on the Phone field
    if (!Schema.sObjectType.Contact.fields.Phone.isAccessible()){
      return null;
    }
    return [SELECT Phone FROM Contact WHERE             
            Id=:contactId].Phone;                                                       
  }
    
  webservice static Integer updatePhone (Id contactId,String Phone) {
    // Check if the user has update access on the Phone field
    if (!Schema.sObjectType.Contact.fields.Phone.isUpdateable()){
      return 1;
    }
    Contact c = [SELECT Phone FROM Contact WHERE Id=:contactId];
    c.Phone = Phone;
    update c;
    return 0;
  }
    
  webservice static Integer deleteContact (Id contactId) {
    // Check if the user has delete access on the Contact object
    if (!Contact.sObjectType.getDescribe().isDeletable()) {
      return 1;
    }
    delete [SELECT Id FROM Contact WHERE Id=: contactId];
    return 0; 
  }
}