const fs = require('fs');
const path = require('path');

/**
 * Extracts a snippet of code centered around a specific line, including a configurable number of context lines before and after.
 * Tabs are replaced with two spaces, and carriage returns are removed.
 * Each line in the snippet is prefixed with its line number.
 *
 * @param {string} code - The full source code as a string.
 * @param {number} line - The 1-based line number to center the snippet around.
 * @param {number} [context=3] - The number of lines of context to include before and after the specified line.
 * @returns {string} The formatted code snippet with line numbers.
 */
function getCodeSnippet(code, line, context = 3) {
	let lines = code.replace(/[\t]/g, '  ');
	lines = lines.replace(/[\r]/g, '').split('\n');
	const start = Math.max(line - context - 1, 0);
	const end = Math.min(line + context, lines.length);

	return lines
		.slice(start, end)
		.map((content, index) => {
			const lineNumber = start + index + 1;
			return `Line ${lineNumber.toString().padStart(3)} | ${content}`;
		})
		.join('\n');
}

/**
 * Analyzes Apex code to detect potential Salesforce governor limit issues caused by DML operations or SOQL queries inside loops.
 *
 * Scans the provided code for loops (for, while, do-while) and checks if any DML operations (insert, update, delete, upsert, merge, undelete)
 * or SOQL queries are present within the loop body. Returns an array of detected issues, each with details such as type, message, line number,
 * loop type, code snippet, suggested fix, documentation link, and timestamp.
 *
 * @param {string} code - The Apex code to analyze for governor limit issues.
 * @returns {Array<Object>} An array of issue objects, each containing:
 *   - {string} type - The type of issue detected (e.g., 'DML_IN_LOOP', 'SOQL_IN_LOOP').
 *   - {string} message - A description of the detected issue.
 *   - {number} line - The line number where the loop starts.
 *   - {string} loopType - The type of loop detected ('for', 'while', or 'do').
 *   - {string[]} codeSnippet - A snippet of code around the detected issue.
 *   - {string} suggestedFix - A suggestion for fixing the issue.
 *   - {string} docLink - A link to relevant Salesforce documentation.
 *   - {string} timestamp - The ISO timestamp when the issue was detected.
 */
function findGovernorLimitIssues(code) {
	const results = [];
	const loopPattern = /(for|while|do)\s*\(.*?\)\s*\{([\s\S]*?)\}/g;
	const dmlDocLink =
		'https://developer.salesforce.com/docs/atlas.en-us.256.0.apexcode.meta/apexcode/langCon_apex_dml.htm';
	const soqlDocLink =
		'https://developer.salesforce.com/docs/atlas.en-us.256.0.apexcode.meta/apexcode/langCon_apex_SOQL.htm';

	const fixes = {
		insert: 'Bulkify by collecting records and insert outside the loop.',
		update: 'Bulkify by collecting records and update outside the loop.',
		delete: 'Bulkify by collecting records and delete outside the loop.',
		upsert: 'Bulkify by collecting records and upsert outside the loop.',
		merge: 'Avoid merge operations inside loops to prevent governor limits.',
		undelete:
			'Avoid undelete operations inside loops to prevent governor limits.',
		soql: 'Move SOQL queries outside loops to avoid hitting limits.',
	};

	let match;
	while ((match = loopPattern.exec(code)) !== null) {
		const loopType = match[1];
		const loopBody = match[2];
		const loopStartLine = code.substring(0, match.index).split('\n').length;
		const snippet = getCodeSnippet(code, loopStartLine).split('\n');

		function pushResult(type, message, suggestedFix, docLink) {
			results.push({
				type,
				message,
				line: loopStartLine,
				loopType,
				codeSnippet: snippet,
				suggestedFix,
				docLink,
				timestamp: new Date().toISOString(),
			});
		}

		if (/insert\s/.test(loopBody)) {
			pushResult(
				'DML_IN_LOOP',
				"DML operation 'insert' detected inside a loop.",
				fixes.insert,
				dmlDocLink
			);
		}

		if (/update\s/.test(loopBody)) {
			pushResult(
				'DML_IN_LOOP',
				"DML operation 'update' detected inside a loop.",
				fixes.update,
				dmlDocLink
			);
		}

		if (/delete\s/.test(loopBody)) {
			pushResult(
				'DML_IN_LOOP',
				"DML operation 'delete' detected inside a loop.",
				fixes.delete,
				dmlDocLink
			);
		}

		if (/upsert\s/.test(loopBody)) {
			pushResult(
				'DML_IN_LOOP',
				"DML operation 'upsert' detected inside a loop.",
				fixes.upsert,
				dmlDocLink
			);
		}

		if (/merge\s/.test(loopBody)) {
			pushResult(
				'DML_IN_LOOP',
				"DML operation 'merge' detected inside a loop.",
				fixes.merge,
				dmlDocLink
			);
		}

		if (/undelete\s/.test(loopBody)) {
			pushResult(
				'DML_IN_LOOP',
				"DML operation 'undelete' detected inside a loop.",
				fixes.undelete,
				dmlDocLink
			);
		}

		if (/select\s+.*\s+from\s+/i.test(loopBody)) {
			pushResult(
				'SOQL_IN_LOOP',
				'SOQL query detected inside a loop.',
				fixes.soql,
				soqlDocLink
			);
		}
	}

	return results;
}

/**
 * Analyzes a given file for Salesforce governor limit issues and writes the results to a JSON file.
 *
 * @async
 * @param {string} filePath - The path to the file to be analyzed.
 * @returns {Promise<void>} Resolves when the analysis and file writing are complete.
 */
async function analyzeFileForGovernorLimits(filePath) {
	const fileName = path.parse(path.basename(filePath)).name;
	const absolutePath = path.resolve(filePath);
	const code = (() => {
		try {
			return fs.readFileSync(absolutePath, 'utf-8');
		} catch (error) {
			console.error(error.message);
			process.exit(1);
		}
	})();

	const results = findGovernorLimitIssues(code);

	const outputDir = path.resolve(__dirname, '../output');
	if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

	fs.writeFileSync(
		path.join(outputDir, fileName + '.json'),
		JSON.stringify(results, null, 2)
	);

	console.log(
		`Analysis Results for ${filePath}: ${results.length} issues found.`
	);

	if (results.length > 0) {
		console.log('See output/' + fileName + '.json for details.');
	} else {
		console.log('No issues found.');
	}
}

module.exports = {
	analyzeFileForGovernorLimits,
};
