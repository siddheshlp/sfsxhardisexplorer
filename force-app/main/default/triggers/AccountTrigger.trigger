trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler handler = new AccountTriggerHandler();
        handler.createContactsForAccounts(Trigger.New);
    }
}