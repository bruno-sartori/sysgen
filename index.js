const MysqlParser = require('./lib/parsers/mysql').default;

console.log(process.argv)

const run = async () => {
	const mysqlParser = new MysqlParser('root', 'root', 'isp_1', 'localhost', '');
	await mysqlParser.parseDatabase();

	return true;
}

run().then(resp => console.log(resp)).catch(error => console.error(error));
