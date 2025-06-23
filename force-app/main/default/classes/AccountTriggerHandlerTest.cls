@isTest
public class AccountTriggerHandlerTest {
    @isTest
    static void testCreateContactsForAccounts() {
        // Create test Accounts
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert accounts;
        //test12346

        // Call the handler method
        //Test.startTest();
        //AccountTriggerHandler.createContactsForAccounts([SELECT Id, Name FROM Account WHERE Name != null]);
        //Test.stopTest();

         //Verify Contacts were created for accounts with Name
       List<Contact> contacts = [SELECT Id, LastName, AccountId FROM Contact];
        System.assertEquals(2, contacts.size(), 'Two contacts should be created');
        for (Contact c : contacts) {
            System.assert(c.LastName == 'Test Account 1' || c.LastName == 'Test Account 2', 'Contact LastName should match Account Name');
        }
    }

}