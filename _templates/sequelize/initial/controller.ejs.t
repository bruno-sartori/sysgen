---
to: app/src/controllers/Controller.js
---
import HttpStatus from 'http-status';
import { Op } from 'sequelize';
import { defaultResponse, errorResponse } from '../util/responses';
import InvalidTypeError, { UNSIGNED_INT, BOOLEAN } from '../error/InvalidTypeError';
import ResourceNotFoundError from '../error/ResourceNotFoundError';
import NoUpdateError from '../error/NoUpdateError';

class Controller {

	constructor(db, PrimaryModel) {
		this.db = db;
		this.PrimaryModel = PrimaryModel;
	}

	static async validateUpdate(response, id) {
		if (response[0] === 0) {
			const obj = await this.PrimaryModel.findById(id);

			if (obj === null) {
				throw new ResourceNotFoundError('Registro não encontrado.');
			} else {
				throw new NoUpdateError();
			}
		}
	}

	static async validateDestroy(response, id) {
		if (response === 0) {
			const obj = await this.PrimaryModel.findById(id);

			if (obj === null) {
				throw new ResourceNotFoundError('Registro não encontrado.');
			} else {
				throw new NoUpdateError('Nenhuma exclusão foi feita.');
			}
		}
	}

	async getById(id) {
		try {
			if (isNaN(id)) {
				throw new InvalidTypeError('id', id, [UNSIGNED_INT], 'ID is not valid');
			}

			const response = await this.PrimaryModel.findById(id);

			if (response === null) {
				throw new ResourceNotFoundError('Resource not found');
			}

			return defaultResponse({}, response);
		} catch (error) {
			return errorResponse(error, error.statusCode || HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}

	async getFilters() { // eslint-disable-line
		try {
			const response = {};

			return defaultResponse({}, response);
		} catch (error) {
			return errorResponse(error, HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}

	async create(data, params = {}) {
		try {
			await this.PrimaryModel.create(data);
			const response = await this.list(params);

			return defaultResponse(response.data.meta, response.data.data, HttpStatus.CREATED);
		} catch (error) {
			return errorResponse(error, HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}

	async update(data, id, params = {}) {
		try {
			if (isNaN(id)) {
				throw new InvalidTypeError('id', id, [UNSIGNED_INT], 'ID is not valid');
			}

			const obj = await this.PrimaryModel.update(data, { where: { id } });
			await Controller.validateUpdate(obj, id);

			const response = await this.list(params);

			return defaultResponse(response.data.meta, response.data.data, HttpStatus.CREATED);
		} catch (error) {
			return errorResponse(error, error.statusCode || HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}

	async destroy(id, params = {}) {
		try {
			let query = {};

			if (!isNaN(id)) {
				query = { where: { id } };
			} else if (/,/.test(id)) {
				query = {
					where: {
						id: { [Op.in]: id.split(',') }
					}
				};
			} else {
				throw new InvalidTypeError('id', id, [UNSIGNED_INT], 'ID is not valid');
			}

			const obj = await this.PrimaryModel.destroy(query);
			await Controller.validateDestroy(obj, id);

			const response = await this.list(params);
			return defaultResponse(response.data.meta, response.data.data, HttpStatus.CREATED);
		} catch (error) {
			return errorResponse(error, error.statusCode || HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}
}

export default Controller;
