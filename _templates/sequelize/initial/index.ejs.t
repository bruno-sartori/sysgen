---
to: app/src/index.js
---
const dotenv = require('dotenv');

let envPath;

switch (process.env.NODE_ENV) {
	case 'production':
		envPath = '../.env.production';
		break;
	case 'test':
		envPath = '../.env.test';
		break;
	case 'development':
		envPath = '../.env';
		break; 
	default:
		envPath = '../.env';
}

dotenv.config({ path: envPath });

const app = require('./app').default;

app.listen(process.env.PORT, () => {
	// eslint-disable-next-line no-console
	console.log(`ISP api running on ${process.env.PORT}`);
});

