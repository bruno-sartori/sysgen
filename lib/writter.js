'use strict';

Object.defineProperty(exports, "__esModule", {
	value: true
});

var _require = require('hygen'),
    runner = _require.runner;

var Logger = require('hygen/lib/logger');
var path = require('path');
var defaultTemplates = path.join(__dirname, '../templates');

var logger = new Logger(console.log.bind(console));

var writter = function writter(args) {
	runner(args, {
		templates: defaultTemplates,
		cwd: process.cwd(),
		logger: logger,
		createPrompter: function createPrompter() {
			return require('enquirer');
		},
		exec: function exec(action, body) {
			var opts = body && body.length > 0 ? { input: body } : {};
			return require('execa').shell(action, opts);
		},
		debug: !!process.env.DEBUG
	});
};

exports.default = writter;