trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        system.debug('inside AccountTrigger after insert-----');
        AccountTriggerHandler.createContactsForAccounts(Trigger.New);
    }
    //please deploy trigger first and then run the test class
}