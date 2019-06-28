---
to: app/src/error/AppError.js
---
import HttpStatus from 'http-status';

class AppError extends Error {
	constructor(message, errno, statusCode = HttpStatus.UNPROCESSABLE_ENTITY) {
		super(message);

		this.errno = errno || 500;
		this.statusCode = statusCode;
		this.type = 'AppError';
		this.name = 'Error in the application';
		this.code = 'ERR_APP_ERROR';
	}
}

export default AppError;