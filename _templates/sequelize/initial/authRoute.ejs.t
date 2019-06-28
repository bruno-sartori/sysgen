---
to: app/src/routes/auth.js
---
import <%= h.inflection.camelize(userTable) %>Controller from '../controllers/<%= h.inflection.camelize(userTable) %>';

export default (app) => {
	const <%= userTable %>Controller = new <%= h.inflection.camelize(userTable) %>Controller(app.datasource.db);

	app.post('/login', async (req, res) => {
		const { <%= userLogin %>: login, <%= userPassword %>: password } = req.body;
		const response = await <%= userTable %>Controller.login(login, password);
        res.status(response.statusCode).json(response.data);
	});
};
