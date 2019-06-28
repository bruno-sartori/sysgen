---
to: app/src/config/datasource.js
---
import Sequelize from 'sequelize';
import fs from 'fs';
import path from 'path';

let database = null;

const loadModels = (sequelize) => {
	const dir = path.join(__dirname, '../models');
	const models = [];
	fs.readdirSync(dir).forEach((file) => {
		const modelDir = path.join(dir, file);
		const model = sequelize.import(modelDir);
		models[model.name] = model;
	});

	Object.keys(models).forEach((modelName) => {
		if (models[modelName].associate) {
			models[modelName].associate(models);
		}
	});

	return models;
};

export default function (app) {
	if (!database) {
		const sequelize = new Sequelize(
			process.env.DB_NAME,
			process.env.DB_USER,
			process.env.DB_PASSWORD,
			{
				host: process.env.DB_HOST,
				dialect: 'mysql',
				logging: null
			}
		);

		database = {
			db: sequelize,
			Sequelize,
		};

		database.db.models = loadModels(sequelize);

		sequelize.sync().done(() => database);
	}
	return database;
}
