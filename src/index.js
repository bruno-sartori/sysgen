#! /usr/bin/env node

const MysqlParser = require('./parsers/mysql').default;
const inquirer = require('inquirer');

const run = async () => {
	const questions = [
		{ name: 'appName', message: 'Application Name?', default: 'API' },
		{ name: 'dbName', message: 'Database Name?', default: 'sysgen' },
		{ name: 'dbHost', message: 'Database Host?', default: 'localhost' },
		{ name: 'dbUser', message: 'Database User?', default: 'root' },
		{ name: 'dbPassword', message: 'Database Password?', default: 'root' },
		{
			name: 'excludeTables',
			message: 'Exclude tables? Ex: table1|table2|..',
			default: 'SequelizeMeta'
		},
		{ name: 'userTable', message: 'Users table name?', default: 'operadores' },
		{ name: 'userLogin', message: 'Login field in users table?', default: 'login' },
		{ name: 'userPassword', message: 'Password field in users table?', default: 'senha' }
	];

	const answers = await inquirer.prompt(questions, (answer) => answer);

	const mysqlParser = new MysqlParser(answers);
	await mysqlParser.parseDatabase();

	return true;
}

run().then(resp => console.log(resp)).catch(error => console.error(error));
