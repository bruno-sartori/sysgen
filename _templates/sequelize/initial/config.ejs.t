---
to: app/src/config/config.js
---
const development = {
	jwtSecret: 'LKS0#1',
	jwtExpire: 28800,
};

const production = {
	jwtSecret: 'LERibAr##',
	jwtExpire: 100000,
};

export default (process.env.NODE_ENV === 'production') ? production : development;
