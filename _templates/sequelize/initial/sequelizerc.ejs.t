---
to: app/.sequelizerc
---

var path = require('path');

module.exports = {
	config: path.resolve('src', 'config', 'babelHook.js'),
	'migrations-path': path.resolve('migrations'),
	'models-path': path.resolve('src', 'models_sequelize'),
	'seeders-path': path.resolve('seeds')
};
