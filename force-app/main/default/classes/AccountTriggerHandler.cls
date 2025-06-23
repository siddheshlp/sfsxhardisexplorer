public with sharing class AccountTriggerHandler {

    public static void createContactsForAccounts(List<Account> newAccounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : newAccounts) {
            if (acc.Name != null) {
                contactsToInsert.add(new Contact(
                    LastName = acc.Name,
                    AccountId = acc.Id
                ));
            }
        }
        //test12345
        if (!contactsToInsert.isEmpty()) {
            if (Schema.sObjectType.Contact.isCreateable()) {
                insert contactsToInsert;
            } else {
                throw new System.DmlException('Insufficient access to create Contact records.');
            }
        }
    }
}