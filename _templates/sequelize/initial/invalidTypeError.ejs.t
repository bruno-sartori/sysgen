---
to: app/src/error/InvalidTypeError.js
---
import AppError from './AppError';

const INTEGER = 'INTEGER';
const UNSIGNED_INT = 'UNSIGNED_INT';
const FLOAT = 'FLOAT';
const UNSIGNED_FLOAT = 'UNSIGNED_FLOAT';
const DATE = 'DATE';
const STRING = 'STRING';
const BOOLEAN = 'BOOLEAN';
const NULL = 'NULL';
const UNDEFINED = 'UNDEFINED';
const OBJECT = 'OBJECT';

class InvalidTypeError extends AppError {
	constructor(variableName, value, expected = [], message = 'Valor Inválido!') {
		super(message, 9001);

		this.name = 'InvalidTypeError';

		value = (typeof value === 'undefined') ? 'undefined' : value;

		this.props = { variableName, value, expected };
	}

}

export default InvalidTypeError;

export { INTEGER, UNSIGNED_INT, UNSIGNED_FLOAT, FLOAT, DATE, STRING, BOOLEAN, OBJECT, NULL, UNDEFINED };