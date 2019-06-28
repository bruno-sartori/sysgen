---
to: app/src/error/ResourceNotFoundError.js
---
import HttpStatus from 'http-status';
import AppError from './AppError';

class ResourceNotFoundError extends AppError {
	constructor(message) {
		// Providing default message and overriding status code.
		super(message || 'Este recurso não foi encontrado ou foi excluído.', 900);
		this.name = 'ResourceNotFoundError';
		this.statusCode = HttpStatus.NOT_FOUND;
	}

}

export default ResourceNotFoundError;