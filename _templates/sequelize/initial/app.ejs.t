---
to: app/src/app.js
---
import express from 'express';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import helmet from 'helmet';
import path from 'path';
import compression from 'compression';
import cors from 'cors';
import routes from './routes/index';
import authRoute from './routes/auth';
import datasource from './config/datasource';
import config from './config/config';
import authorization from './auth';
import logger from './util/logger';
import error404Middleware from './middlewares/error404';

const whitelist = [
	'http://localhost:8000'
];

const app = express();
app.config = config;
app.logger = logger;
app.datasource = datasource(app);

// Initializing express middlewares
app.use('/static', express.static(path.join(__dirname, '/public')));
app.use(morgan(':method :url :status :response-time ms', { stream: logger.stream }));
app.use(helmet());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(compression());
app.use(cors({
	origin: (origin, callback) => {
		if (whitelist.indexOf(origin) !== -1 || process.env.NODE_ENV === 'test') {
			callback(null, true);
		} else {
			app.logger.error(`Not allowed by CORS, origin: ${origin}`);
			callback(new Error('Not allowed by CORS'));
		}
	}
}));

app.auth = authorization(app);
app.use(app.auth.initialize());

authRoute(app);

app.route('*').all(app.auth.authenticate(), app.auth.getToken(), auditMiddleware(app));

routes(app);

app.use(error404Middleware);

export default app;
