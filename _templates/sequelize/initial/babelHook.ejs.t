---
to: app/src/config/babelHook.js
---
require('@babel/register');

const config = require('./sequelize.json');

const env = process.env.NODE_ENV || 'development';

module.exports = config[env];
