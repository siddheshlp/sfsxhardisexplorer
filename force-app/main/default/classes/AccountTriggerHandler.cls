public with sharing class AccountTriggerHandler {

    /**
     * @description Creates a contact for each new account.
     * @param newAccounts The list of new accounts.
     */
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
        
        // Check if there are any contacts to insert to avoid DML errors.
        if (!contactsToInsert.isEmpty()) {
            // Check for createable permission before inserting.
            if (Schema.sObjectType.Contact.isCreateable()) {
                insert contactsToInsert;
            } else {
                // Throw an exception if the user does not have the required permissions.
                throw new System.DmlException('Insufficient access to create Contact records.');
            }
        }
    }

    /**
     * @description Creates an opportunity for each account provided in the input list.
     * The opportunity will have its name set to the account name appended with '-opportunity',
     * the close date set to the last day of the current month, and the stage set to 'Prospecting'.
     * @param newAccounts The list of new accounts for which to create opportunities.
     */
    public static void createOpportunityForAccounts(List<Account> newAccounts) {
        // Create a list to hold the new opportunities to be inserted.
        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();

        // Calculate the last day of the current month.
        Date today = Date.today();
        Date lastDayOfMonth = today.toStartOfMonth().addMonths(1).addDays(-1);

        // Loop through each new account to create a corresponding opportunity.
        for (Account acc : newAccounts) {
            // Create a new Opportunity sObject
            Opportunity opp = new Opportunity();
            
            // Set the required fields for the new opportunity.
            opp.Name = acc.Name + '-opportunity';
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = lastDayOfMonth;
            
            // Add the newly created opportunity to the list.
            opportunitiesToCreate.add(opp);
        }

        // Check if there are any opportunities to insert to avoid unnecessary DML operations.
        if (!opportunitiesToCreate.isEmpty()) {
            // Insert the list of new opportunities into the database.
            // A try-catch block is used for robust error handling.
            try {
                insert opportunitiesToCreate;
            } catch (DmlException e) {
                // In case of an error during insertion, log it to the debug log.
                // This helps in debugging issues without crashing the trigger execution.
                System.debug('Could not create opportunities. Error: ' + e.getMessage());
            }
        }
    }
}
