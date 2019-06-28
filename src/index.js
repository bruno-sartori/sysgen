#! /usr/bin/env node

const MysqlParser = require('./parsers/mysql').default;
const inquirer = require('inquirer');

console.log(process.argv)

const run = async () => {
	const questions = [
		{ name: 'appName', message: 'Application Name?', default: 'API' },
		{ name: 'dbName', message: 'Database Name?', default: 'isp_1' },
		{ name: 'dbHost', message: 'Database Host?', default: 'localhost' },
		{ name: 'dbUser', message: 'Database User?', default: 'root' },
		{ name: 'dbPassword', message: 'Database Password?', default: 'root' },
		{
			name: 'excludeTables',
			message: 'Exclude tables? Ex: table1|table2|..',
			// doing this only for my test database
			default: 'knex_migrations|knex_migrations_lock|federated_clientes|federated_base_banco|federated_base_operadora_boleto|federated_base_operadora_cartao|federated_isp_fabricante|federated_notifications'
		}
	];

	const answers = await inquirer.prompt(questions, (answer) => answer);

	const mysqlParser = new MysqlParser(answers);
	await mysqlParser.parseDatabase();

	return true;
}

run().then(resp => console.log(resp)).catch(error => console.error(error));
