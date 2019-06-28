---
to: app/src/util/logger.js
---
import winston from 'winston';
import path from 'path';
import moment from 'moment';

const format = winston.format;

const customFormat = format.combine(
	format.timestamp(),
	format.printf(info => `\n----------------------------------------\n\n${moment(info.timestamp).format('DD/MM/YYYY HH:mm:ss')} - ${info.level.toUpperCase()}: ${info.message}`)
);

const logger = winston.createLogger({
	exitOnError: false,
	format: customFormat,
	transports: [
		new winston.transports.File({
			filename: path.join(__dirname, '../../logs/error.log'),
			level: 'error',
		}),
		new winston.transports.File({
			filename: path.join(__dirname, '../../logs/combined.log'),
		}),
	],
	exceptionHandlers: [
		new winston.transports.File({ 
			filename: path.join(__dirname, '../../logs/exceptions.log'),
		}),
		new winston.transports.File({
			filename: path.join(__dirname, '../../logs/combined.log'),
		})
	]
});

logger.stream = {
	write: (message) => {
		logger.info(message);
	}
};

if (process.env.NODE_ENV === 'development') {
	logger.add(new winston.transports.Console({
		format: format.combine(format.colorize(), format.printf(info => `${info.level}: ${info.message}`)),
		name: 'Debug',
		level: 'debug',
		handleExceptions: true,
		prettyPrint: true,
		colorize: true
	}));
}

export default logger;
