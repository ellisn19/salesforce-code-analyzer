const { analyzeFileForGovernorLimits } = require('./src/analyzer');

async function main() {
	const args = process.argv.slice(2);

	if (args[0] === 'analyze') {
		if (args[1] === undefined) {
			console.error('❌ Usage: npm run analyze path/to/triggerOrClass');
			process.exit(1);
		}
		analyzeFileForGovernorLimits(args[1]);
	}
}

if (require.main === module) {
	main();
}

module.exports = { main };
