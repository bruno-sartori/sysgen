---
to: app/src/auth.js
---

import passport from 'passport';
import { Strategy, ExtractJwt } from 'passport-jwt';

export default (app) => {
	const logger = app.logger;
	const User = app.datasource.models.User;
	const opts = {};
	opts.secretOrKey = app.config.jwtSecret;
	opts.jwtFromRequest = ExtractJwt.fromAuthHeader();

	const strategy = new Strategy(opts, async (payload, done) => {
		try {
			const user = await Operador.findOne({ id: payload.id });

			if (user) {
				return done(null, {
					id: user.id,
					login: user.login,
				});
			}

			return done(null, false);
		} catch (error) {
			return done(error, null);
		}
	});

	passport.use(strategy);

	return {
		initialize: () => passport.initialize(),
		authenticate: () => passport.authenticate('jwt', { session: false }),
		getToken: () => (req, res, next) => {
			const token = (typeof req.headers.authorization !== 'undefined') ? req.headers.authorization.replace('JWT ', '') : null;
			if (token !== null) {
				const decoded = jwt.decode(token, config.jwtSecret);
				logger.debug(`[getToken] - ${JSON.stringify(decoded)}`);
				res.locals.token = decoded;
			}

			next();
		}
	};
};
