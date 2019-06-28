---
to: app/eslintrc.json
---

{
  "extends": ["airbnb", "prettier", "plugin:compat/recommended"],
  "parserOptions": {
    "ecmaVersion": 8,
    "sourceType": "module"
  },
  "rules": {
		"global-require": "off",
		"radix": "off",
		"no-plusplus": "off",
		"compat/compat": "off",
		"max-len": ["error", 300],
    "no-param-reassign": "off",
    "func-names": "off",
    "no-underscore-dangle": "off"
  },
  "globals": {
    "describe": true,
    "it": true,
    "expect": true,
    "app": true,
    "td": true,
	"beforeEach": true,
	"afterEach": true,
	"jest": true,
    "request": true,
    "Joi": true,
    "joiAssert": true
  }
}
