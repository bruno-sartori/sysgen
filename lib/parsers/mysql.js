'use strict';

Object.defineProperty(exports, "__esModule", {
	value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _lodash = require('lodash');

var _lodash2 = _interopRequireDefault(_lodash);

var _chalk = require('chalk');

var _chalk2 = _interopRequireDefault(_chalk);

var _sequelize = require('sequelize');

var _sequelize2 = _interopRequireDefault(_sequelize);

var _writter = require('../writter');

var _writter2 = _interopRequireDefault(_writter);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var MysqlParser = function () {
	function MysqlParser(dbUser, dbPassword, dbName) {
		var dbHost = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : 'localhost';
		var excludeTables = arguments[4];

		_classCallCheck(this, MysqlParser);

		this.db = new _sequelize2.default(dbName, dbUser, dbPassword, {
			host: dbHost,
			dialect: 'mysql',
			logging: null
		});

		this.dbName = dbName;
		this.models = [];
		this.excludeTables = excludeTables.split('|');
	}

	_createClass(MysqlParser, [{
		key: 'getType',
		value: function getType(type) {
			var types = {
				datetime: 'DATE',
				int: 'INTEGER',
				varchar: 'STRING',
				tinyint: 'BOOLEAN',
				decimal: 'FLOAT',
				float: 'FLOAT',
				text: 'STRING'
			};

			var trueType = type.match(/.+?(?=\()/);

			trueType = trueType === null ? type : trueType[0];

			return types[trueType];
		}
	}, {
		key: 'getModel',
		value: async function getModel(table) {
			var _this = this;

			var columns = await this.db.query('show columns from ' + table);
			var modelColumns = await columns[0].map(function (o) {
				return { name: o.Field, type: _this.getType(o.Type) };
			});
			this.models.push({ name: table, columns: modelColumns });
		}
	}, {
		key: 'getModels',
		value: async function getModels() {
			var tables = await this.db.getQueryInterface().showAllSchemas();

			for (var i = 0; i < tables.length; i++) {
				var table = tables[i]['Tables_in_' + this.dbName];
				console.log('[' + _chalk2.default.blue('parsing:') + '] ' + _chalk2.default.gray(table)); // eslint-disable-line
				if (this.excludeTables.includes(table)) {
					console.log('[' + _chalk2.default.blue('excluding table:') + '] ' + _chalk2.default.green(table)); // eslint-disable-line
				} else {
					await this.getModel(table);
				}
			}

			if (this.models.length === 0) {
				throw new Error('O banco de dados não possuí nenhuma tabela criada!');
			}
		}
	}, {
		key: 'parseDatabase',
		value: async function parseDatabase() {
			try {
				await this.getModels();
				await this.generateFiles();
				return true;
			} catch (error) {
				throw error;
			}
		}
	}, {
		key: 'generateFiles',
		value: async function generateFiles() {
			try {
				for (var i = 0; i < this.models.length; i++) {
					var args = 'sequelize new --name ' + this.models[i].name + ' --columns ' + JSON.stringify(this.models[i].columns);
					(0, _writter2.default)(args);
				}

				return true;
			} catch (error) {
				console.log("OUTRO ERRO" + error);
				throw error;
			}
		}
	}]);

	return MysqlParser;
}();

exports.default = MysqlParser;