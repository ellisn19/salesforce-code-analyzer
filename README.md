[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# salesforce-code-analyzer



## Overview

A Node.js tool for analyzing Salesforce Apex triggers and classes for bulk-safety and performance issues. Detects SOQL/DML in loops, checks best practices, and optionally stress tests triggers with simulated data inserts.

## Features

- **Bulk-Safety Analysis**: Detects SOQL and DML operations inside loops in Apex triggers.
- **Command Line Interface**: Easy-to-use CLI for quick analysis.

## Setup

Clone this repository and install dependencies:

   ```bash
   git clone https://github.com/<yourusername>/salesforce-code-analyzer.git
   cd salesforce-code-analyzer
   npm install
   ```

## Usage

Run the analyzer on a directory containing Apex trigger files:

```bash
npm run analyze path/to/triggerOrClass
```

This will:

- Read the Apex Trigger or Class file

- Find any instance of DML or SOQL inside of a loop

- Write the output to `output/<fileName>.json`

## Example Output

```json
  {
    "type": "DML_IN_LOOP",
    "message": "DML operation 'insert' detected inside a loop.",
    "line": 6,
    "loopType": "for",
    "codeSnippet": [
      "Line   3 |   public static void forLoopDml(String[] args) {",
      "Line   4 |     List<Contact> contacts = new ArrayList<>();",
      "Line   5 |     ",
      "Line   6 |     for (Integer i = 0; i < 5; i++) {",
      "Line   7 |       Contact contact = new Contact(LastName = 'ForContact' + i, AccountId = Id.generate());",
      "Line   8 |       insert contact;",
      "Line   9 |       contacts.add(contact);"
    ],
    "suggestedFix": "Bulkify by collecting records and insert outside the loop.",
    "docLink": "https://developer.salesforce.com/docs/atlas.en-us.256.0.apexcode.meta/apexcode/langCon_apex_dml.htm",
    "timestamp": "2025-08-07T17:44:04.312Z"
  }
```

## Project Structure

```
salesforce-etl-json/
├── codeToAnalyze/    # Can put classes or triggers for testing
├── config/           # Config
├── output/           # Generated directory where JSON output files get put
├── src/
│ ├── index.js        # Entry point
│ ├── analyzer.js     # Analyzes files for SOQL or DML inside of loops
├── package.json
├── README.md
└── .gitignore
```

## Extending

- Bulk data generation / bulk data trigger testing

## License

MIT

Feel free to reach out if you want help adding features!
