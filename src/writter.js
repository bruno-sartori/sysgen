const { runner } = require('hygen')
const Logger = require('hygen/lib/logger')
const path = require('path')
const defaultTemplates = path.join(__dirname, '../_templates')

const logger = new Logger(console.log.bind(console));

const writter = (args) => {
	runner(args, {
		templates: defaultTemplates,
		cwd: process.cwd(),
		logger,
		createPrompter: () => require('enquirer'),
		exec: (action, body) => {
			const opts = body && body.length > 0 ? { input: body } : {}
			return require('execa').shell(action, opts)
		},
		debug: !!process.env.DEBUG
	});
};

export default writter;