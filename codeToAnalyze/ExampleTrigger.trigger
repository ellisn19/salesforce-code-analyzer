trigger SampleTrigger on Account (before insert, before update) {
    
    // FOR loop with DML
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        insert new Contact(LastName = 'LoopContact', AccountId = Trigger.new[i].Id);
    }

    // FOR-EACH loop with SOQL
    for (Account acc : Trigger.new) {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
    }

    // WHILE loop with DML
    Integer count = 0;
    while (count < Trigger.new.size()) {
        delete Trigger.new[count];
        count++;
    }

    // DO-WHILE loop with SOQL
    Integer j = 0;
    do {
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :Trigger.new[j].Id];
        j++;
    } while (j < Trigger.new.size());

    // Loop with Update
    for (Account acc : Trigger.new) {
        acc.Name = acc.Name + ' Updated';
        update acc;
    }

    // Loop with Upsert
    for (Account acc : Trigger.new) {
        upsert acc;
    }

    // Merge DML inside a loop
    for (Integer k = 0; k < Trigger.new.size() - 1; k += 2) {
        merge Trigger.new[k] Trigger.new[k + 1];
    }

    // Undelete DML
    for (Account acc : Trigger.new) {
        undelete acc;
    }

    // Loop with dynamic SOQL
    for (Account acc : Trigger.new) {
        String query = 'SELECT Id FROM Contact WHERE AccountId = \'' + acc.Id + '\'';
        List<Contact> dynamicContacts = Database.query(query);
    }

    // Direct SOQL outside of a loop (should not be flagged)
    List<Account> allAccounts = [SELECT Id FROM Account];

    // DML outside of a loop (should not be flagged)
    insert new Account(Name = 'OutsideInsert');

}
