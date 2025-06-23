trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        system.debug('inside AccountTrigger after insert-----');
        AccountTriggerHandler.createContactsForAccounts(Trigger.New);
    }
    //test12345678
}