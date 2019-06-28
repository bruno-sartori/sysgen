---
to: app/src/routes/index.js
---
import fs from 'fs';

export default (app) => {
	fs.readdirSync(__dirname).forEach((file) => {
		if (file === 'index.js' || file === 'auth.js') return;
		const name = file.substr(0, file.indexOf('.'));
		require(`./${name}`).default(app);
	});
};