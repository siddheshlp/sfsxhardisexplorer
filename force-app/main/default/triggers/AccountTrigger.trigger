trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.createContactsForAccounts(Trigger.New);
    }
    //test12345
}