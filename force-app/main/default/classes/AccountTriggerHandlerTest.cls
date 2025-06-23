@isTest
public with sharing class AccountTriggerHandlerTest {

    /**
     * @description Tests the createContactsForAccounts method of the AccountTriggerHandler class.
     * It verifies that a contact is created for each new account.
     */
    @isTest
    static void testCreateContactsForAccounts() {
        // Create a list of test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        
        // Insert the test accounts, which will fire the trigger
        insert testAccounts;

        // Query for the contacts that should have been created by the trigger handler
        List<Contact> createdContacts = [SELECT Id, LastName, AccountId FROM Contact];

        // Assert that the number of created contacts matches the number of accounts
        System.assertEquals(testAccounts.size(), createdContacts.size(), 'A contact should have been created for each account.');

        // Further assertions can be added to check contact details
        for(Integer i = 0; i < testAccounts.size(); i++) {
            System.assertEquals(testAccounts[i].Name, createdContacts[i].LastName, 'Contact LastName should match the Account Name.');
        }

        // 3. Verification: Query the created opportunities and assert the results
        List<Opportunity> createdOpps = [SELECT Id, Name, AccountId, StageName, CloseDate FROM Opportunity];

        // Calculate the expected close date (last day of the current month)
        Date expectedCloseDate = Date.today().toStartOfMonth().addMonths(1).addDays(-1);

        // Assert that the correct number of opportunities were created
        System.assertEquals(testAccounts.size(), createdOpps.size(), 'An opportunity should have been created for each account.');

        // Loop through and verify the details of each created opportunity
        for (Integer i = 0; i < testAccounts.size(); i++) {
            Account acc = testAccounts[i];
            Opportunity opp = createdOpps[i];

            System.assertEquals(acc.Name + '-opportunity', opp.Name, 'Opportunity name is incorrect.');
            System.assertEquals('Prospecting', opp.StageName, 'Opportunity stage should be Prospecting.');
            System.assertEquals(expectedCloseDate, opp.CloseDate, 'Opportunity close date is incorrect.');
            System.assertEquals(acc.Id, opp.AccountId, 'Opportunity should be linked to the correct account.');
        }
    }

    
}
