---
to: app/src/routes/<%= h.inflection.camelize(name, true) %>.js
---

<%
	nameCamel = h.inflection.camelize(name)
	nameSingle = h.inflection.singularize(name)
%>


import <%= nameCamel %>Controller from '../controllers/<%= nameCamel %>';
import AccessController from '../controllers/AccessControl2';

export default (app) => {
	let <%= nameSingle %>;
	let acl;

	app.route('/<%= name %>*')
	.all(
		async (req, res, next) => {
			const { <%= nameCamel %>, AccessControl2, AccessControlPrivileges, Operador } = app.datasource.db_sequelize.models;
			<%= nameSingle %> = new <%= nameCamel %>Controller(app.datasource.db_sequelize, <%= nameCamel %>);
			acl = new AccessController(app.datasource.db_sequelize, AccessControl2, AccessControlPrivileges, Operador);
			next();
		}
	);

	app.route('/<%= name %>')
	.get(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'view' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.list(req.query);
			res.locals = { ...res.locals, body: req.body, statusCode: response.statusCode, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	)
	.post(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'new' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.create(req.body);
			res.locals = { ...res.locals, body: req.body, statusCode: response.statusCode, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	);

	app.route('/<%= name %>/filters')
	.get(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'view' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.getFilters();
			res.locals = { ...res.locals, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	);

	app.route('/<%= name %>/totals')
	.get(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'totals' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.getTotals(req.query);
			res.locals = { ...res.locals, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	);

	app.route('/<%= name %>/:id')
	.get(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'view' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.getById(req.params.id);
			res.locals = { ...res.locals, body: req.body, statusCode: response.statusCode, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	)
	.put(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'update' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.update(req.body, req.params.id, req.query);
			res.locals = { ...res.locals, body: req.body, statusCode: response.statusCode, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	)
	.delete(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'destroy' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.destroy(req.params.id, req.query);
			res.locals = { ...res.locals, body: req.body, statusCode: response.statusCode, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	);

	app.route('/<%= name %>/:id/status')
	.put(
		async (req, res, next) => acl.middleware(req, res, next, { ...options, privilege: 'changeStatus' }),
		async (req, res) => {
			const response = await <%= nameSingle %>.changeStatus(req.body.status, req.params.id, req.query);
			res.locals = { ...res.locals, body: req.body, statusCode: response.statusCode, disable: true };
			res.status(response.statusCode).json(response.data);
		}
	);
};
