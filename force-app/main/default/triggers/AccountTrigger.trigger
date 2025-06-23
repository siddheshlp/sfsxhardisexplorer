trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.createContactsForAccounts(Trigger.New);
        System.debug('Executing after insert trigger');
        AccountTriggerHandler.createOpportunityForAccounts(Trigger.New);
    }
}