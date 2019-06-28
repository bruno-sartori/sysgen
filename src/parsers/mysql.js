import path from 'path';
import _ from 'lodash';
import chalk from 'chalk';
import Sequelize from 'sequelize';
import writter from '../writter';

class MysqlParser {
	constructor(data) {
		const { appName, dbName, dbHost, dbUser, dbPassword, userTable, userLogin, userPassword, excludeTables } = data;
		
		this.appName = appName;
		this.dbName = dbName;
		this.dbHost = dbHost;
		this.dbUser = dbUser;
		this.dbPassword = dbPassword;
		this.userTable = userTable;
		this.userLogin = userLogin;
		this.userPassword = userPassword;

		this.db = new Sequelize(dbName, dbUser, dbPassword, {
			host: dbHost,
			dialect: 'mysql',
			logging: null
		});

		this.models = [];
		this.excludeTables = excludeTables.split('|');
	}

	getType(type) {
		const types = {
			datetime: 'DATE',
			int: 'INTEGER',
			varchar: 'STRING',
			tinyint: 'BOOLEAN',
			decimal: 'FLOAT',
			float: 'FLOAT',
			text: 'STRING'
		};

		let trueType = type.match(/.+?(?=\()/);

		trueType = (trueType === null) ? type : trueType[0];

		return types[trueType];
	}

	async getModel(table) {
		const columns = await this.db.query(`show columns from ${table}`);
		const modelColumns = await columns[0].map(o => ({ name: o.Field, type: this.getType(o.Type) }));
		this.models.push({ name: table, columns: modelColumns });
	}

	async getModels() {
		const tables = await this.db.getQueryInterface().showAllSchemas();

		for (let i = 0; i < tables.length; i++) {
			const table = tables[i][`Tables_in_${this.dbName}`];
			console.log(`[${chalk.blue('parsing:')}] ${chalk.gray(table)}`); // eslint-disable-line
			if (this.excludeTables.includes(table)) {
				console.log(`[${chalk.blue('excluding table:')}] ${chalk.green(table)}`); // eslint-disable-line
			} else {
				await this.getModel(table);
			}
		}

		if (this.models.length === 0) {
			throw new Error('O banco de dados não possuí nenhuma tabela criada!');
		}
	}

	async parseDatabase() {
		try {
			await this.getModels();
			await this.generateFiles();
			return true;
		} catch (error) {
			throw error;
		}
	}

	async generateFiles() {
		try {
			const initialArgs = `sequelize initial --name ${this.appName} --dbHost ${this.dbHost} --dbName ${this.dbName} --dbUser ${this.dbUser} --dbPassword ${this.dbPassword} --userTable ${this.userTable} --userLogin ${this.userLogin} --userPassword ${this.userPassword}`;
			writter(initialArgs);

			for (let i = 0; i < this.models.length; i++) {
				console.log(this.userTable);
				const args = `sequelize new --name ${this.models[i].name} --columns ${JSON.stringify(this.models[i].columns)} --userTable ${this.userTable} --userLogin ${this.userLogin} --userPassword ${this.userPassword}`;
				writter(args);
			}

			return true;
		} catch (error) {
			console.log("OUTRO ERRO" + error);
			throw error;
		}
	}
}

export default MysqlParser;