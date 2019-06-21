---
to: app/controllers/<%= h.inflection.camelize(name) %>.js
---

<%
	Name = h.inflection.camelize(name)
%>

import HttpStatus from 'http-status';
import { Op } from 'sequelize';
import { defaultResponse, errorResponse } from '../util/responses';
import Controller from './Controller';

class <%= Name %>Controller extends Controller {

	constructor(db, <%= Name %>) {
		super(db, <%= Name %>);
		this.<%= Name %> = <%= Name %>;
	}

	async getFilters() {
		try {
			const response = {};

			return defaultResponse({}, response);
		} catch (error) {
			return errorResponse(error, HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}

	async list(params) {
		try {
			const {
				currentPage = 1,
				pageSize = 9,
				sorter = 'id_ascend',
				createdAt = [],
				status,
				txt,
				...conditions
			} = params;
			const { where, fn, literal, col, and } = this.db;
			const offset = pageSize * Math.max(0, currentPage) - pageSize;
			const attributes = [[fn('lpad', col('id'), '6', '0'), 'key'], 'nome', 'status', 'createdAt', 'updatedAt'];

			if (createdAt.length > 0) {
				conditions.createdAt = { [Op.between]: createdAt };
			}

			if (typeof status !== 'undefined' && status !== '') {
				if (/\,/.test(status)) {
					const queryStatus = status.split(',');
					conditions.status = { [Op.in]: queryStatus };
				} else {
					conditions.status = status;
				}
			}

			const query = {
				attributes,
				where: conditions,
				limit: parseInt(pageSize, 10),
				offset
			};

			// sorter = 'Column_ascend'
			if (typeof sorter !== 'undefined') {
				const sorting = sorter.split('_');
				const column = sorting[0];
				const order = { ascend: 'asc', descend: 'desc' };
				query.order = [[literal(column), order[sorting[1]]]];
			}

			if (typeof txt !== 'undefined' && txt !== '') {
				query.where = and(
					query.where,
					where(
						fn('concat',
							literal('nome'),
							fn('date_format', col('createdAt'), '%d/%m/%Y %H:%i:%s'),
							fn('date_format', col('createdAt'), '%d/%m/%Y  %H:%i:%s'),
						),
						{ like: `%${txt}%` }
					)
				);
			}

			const [list, recordsTotal] = await Promise.all([
				this.<%= Name %>.findAll(query),
				this.<%= Name %>.count({ where: query.where })
			]);

			const pagination = {
				current: parseInt(currentPage, 10),
				pageSize: parseInt(pageSize, 10),
				total: recordsTotal,
				pageSizeOptions: ['9', '25', '50', '75', '100'],
			};

			return defaultResponse({}, { list, pagination });
		} catch (error) {
			return errorResponse(error);
		}
	}

	async getTotals(params) {
		try {
			const { txt } = params;

			const query = {
				raw: true,
				subQuery: false,
				where: {}
			};

			if (typeof txt !== 'undefined' && txt !== '') {
				query.where = { ...query.where, nome: { like: `%${txt}%` } };
			}

			const [total, enabled, disabled] = await Promise.all([
				this.<%= Name %>.count(query),
				this.<%= Name %>.count({ ...query, where: { ...query.where, status: true } }),
				this.<%= Name %>.count({ ...query, where: { ...query.where, status: false } })
			]);

			const response = [
				{ title: 'Ativos', value: enabled },
				{ title: 'Desativados', value: disabled },
				{ title: 'Total', value: total }
			];

			return defaultResponse({}, response);
		} catch (error) {
			return errorResponse(error, HttpStatus.UNPROCESSABLE_ENTITY);
		}
	}

}

export default <%= Name %>Controller;
