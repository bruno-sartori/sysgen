---
to: app/src/error/NoUpdateError.js
---
import HttpStatus from 'http-status';
import AppError from './AppError';

class NoUpdateError extends AppError {
    constructor(message) {
        // Providing default message and overriding status code.
        super(message || 'Nenhuma alteração foi feita.', 900);
        this.name = 'NoUpdateError';
        this.statusCode = HttpStatus.UNPROCESSABLE_ENTITY;
    }
}

export default NoUpdateError;