public class  ExampleClass {
	// FOR Loop with DML
	public static void forLoopDml(String[] args) {
		List<Contact> contacts = new ArrayList<>();
		
		for (Integer i = 0; i < 5; i++) {
			Contact contact = new Contact(LastName = 'ForContact' + i, AccountId = Id.generate());
			insert contact;
			contacts.add(contact);
		}
	}

	// FOR-EACH Loop with SOQL
	public static void forEachLoopSoql(String[] args) {
		List<Account> accounts = new ArrayList<>();
		
		for (Account acc : [SELECT Id FROM Account]) {
			Contact[] contacts = [
				SELECT Id 
				FROM Contact 
				WHERE AccountId = :acc.Id
			];
			
			// Do something with the contacts array
			
		}
	}

	// WHILE Loop with DML
	public static void whileLoopDml(String[] args) {
		List<Contact> contacts = new ArrayList<>();
		
		Integer count = 0;
		
		while (count < 5) {
			Contact contact = new Contact(LastName = 'WhileContact' + count, AccountId = Id.generate());
			insert contact;
			contacts.add(contact);
			count++;
		}
	}

	// DO-WHILE Loop with SOQL
	public static void doWhileLoopSoql(String[] args) {
		List<Opportunity> opps = new ArrayList<>();
		
		Integer j = 0;
		
		do {
			Opportunity opportunity = [
				SELECT Id 
				FROM Opportunity 
				WHERE AccountId = :Trigger.new[j].Id
			];
			
			// Do something with the opportunity
			
			j++;
		} while (j < Trigger.new.size());
	}

	// Loop with Update
	public static void loopUpdate(String[] args) {
		List<Account> accounts = new ArrayList<>();
		
		for (Account acc : [SELECT Id FROM Account]) {
			acc.Name += ' Updated';
			update acc;
			
			// Do something else
			
		}
	}

	// Loop with Upsert
	public static void loopUpsert(String[] args) {
		List<Account> accounts = new ArrayList<>();
		
		for (Account acc : [SELECT Id FROM Account]) {
			upsert acc;
			
			// Do something else
			
		}
	}

	// Merge DML inside a loop
	public static void mergeDmlInsideLoop(String[] args) {
		List<Contact> contacts = new ArrayList<>();
		
		for (Integer k = 0; k < 5 - 1; k += 2) {
			Contact contact1 = new Contact(LastName = 'MergeContact' + k, AccountId = Id.generate());
			insert contact1;
			
			Contact contact2 = new Contact(LastName = 'MergeContact' + (k+1), AccountId = Id.generate());
			insert contact2;
			
		}
	}

	// Undelete DML
	public static void undeleteDml(String[] args) {
		List<Account> accounts = new ArrayList<>();
		
		for (Account acc : [SELECT Id FROM Account]) {
			undelete acc;
			
			// Do something else
			
		}
	}

	// Loop with dynamic SOQL
	public static void loopDynamicSoql(String[] args) {
		List<Contact> contacts = new ArrayList<>();
		
		for (Account acc : [SELECT Id FROM Account]) {
			String query = 'SELECT Id FROM Contact WHERE AccountId = \'' + acc.Id + '\'';
			List<Contact> dynamicContacts = Database.query(query);
			
			// Do something with the dynamicContacts array
			
		}
	}

	// Direct SOQL outside of a loop
	public static void directSoqlOutsideLoop(String[] args) {
		String query = 'SELECT Id FROM Contact WHERE AccountId = ''12345''';
		List<Contact> contacts = Database.query(query);
		
		// Do something with the contacts array
		
	}

	// DML outside of a loop
	public static void dmlOutsideLoop(String[] args) {
		insert new Account(Name = 'OutsideInsert');
		
		// Do something else
		
	}

	public class  InnerClass {
		// FOR Loop with DML
		public static void forLoopDml(String[] args) {
			List<Contact> contacts = new ArrayList<>();
			
			for (Integer i = 0; i < 5; i++) {
				Contact contact = new Contact(LastName = 'ForContact' + i, AccountId = Id.generate());
				insert contact;
				contacts.add(contact);
			}
		}

		// FOR-EACH Loop with SOQL
		public static void forEachLoopSoql(String[] args) {
			List<Account> accounts = new ArrayList<>();
			
			for (Account acc : [SELECT Id FROM Account]) {
				Contact[] contacts = [
					SELECT Id 
					FROM Contact 
					WHERE AccountId = :acc.Id
				];
				
				// Do something with the contacts array
				
			}
		}

		// WHILE Loop with DML
		public static void whileLoopDml(String[] args) {
			List<Contact> contacts = new ArrayList<>();
			
			Integer count = 0;
			
			while (count < 5) {
				Contact contact = new Contact(LastName = 'WhileContact' + count, AccountId = Id.generate());
				insert contact;
				contacts.add(contact);
				count++;
			}
		}

		// DO-WHILE Loop with SOQL
		public static void doWhileLoopSoql(String[] args) {
			List<Opportunity> opps = new ArrayList<>();
			
			Integer j = 0;
			
			do {
				Opportunity opportunity = [
					SELECT Id 
					FROM Opportunity 
					WHERE AccountId = :Trigger.new[j].Id
				];
				
				// Do something with the opportunity
				
				j++;
			} while (j < Trigger.new.size());
		}

		// Loop with Update
		public static void loopUpdate(String[] args) {
			List<Account> accounts = new ArrayList<>();
			
			for (Account acc : [SELECT Id FROM Account]) {
				acc.Name += ' Updated';
				update acc;
				
				// Do something else
				
			}
		}

		// Loop with Upsert
		public static void loopUpsert(String[] args) {
			List<Account> accounts = new ArrayList<>();
			
			for (Account acc : [SELECT Id FROM Account]) {
				upsert acc;
				
				// Do something else
				
			}
		}

		// Merge DML inside a loop
		public static void mergeDmlInsideLoop(String[] args) {
			List<Contact> contacts = new ArrayList<>();
			
			for (Integer k = 0; k < 5 - 1; k += 2) {
				Contact contact1 = new Contact(LastName = 'MergeContact' + k, AccountId = Id.generate());
				insert contact1;
				
				Contact contact2 = new Contact(LastName = 'MergeContact' + (k+1), AccountId = Id.generate());
				insert contact2;
				
			}
		}

		// Undelete DML
		public static void undeleteDml(String[] args) {
			List<Account> accounts = new ArrayList<>();
			
			for (Account acc : [SELECT Id FROM Account]) {
				undelete acc;
				
				// Do something else
				
			}
		}

		// Loop with dynamic SOQL
		public static void loopDynamicSoql(String[] args) {
			List<Contact> contacts = new ArrayList<>();
			
			for (Account acc : [SELECT Id FROM Account]) {
				String query = 'SELECT Id FROM Contact WHERE AccountId = \'' + acc.Id + '\'';
				List<Contact> dynamicContacts = Database.query(query);
				
				// Do something with the dynamicContacts array
				
			}
		}

		// Direct SOQL outside of a loop
		public static void directSoqlOutsideLoop(String[] args) {
			String query = 'SELECT Id FROM Contact WHERE AccountId = ''12345''';
			List<Contact> contacts = Database.query(query);
			
			// Do something with the contacts array
			
		}

		// DML outside of a loop
		public static void dmlOutsideLoop(String[] args) {
			insert new Account(Name = 'OutsideInsert');
			
			// Do something else
			
		}
	}
}


