---
to: app/.babelrc
---

{
  "presets": [
	  	[
			"@babel/preset-env",
			{
				"targets": {
					"node": "current"
				}
			}
		]
	],
	"plugins": ["@babel/plugin-proposal-object-rest-spread", ["add-module-exports", { "addDefaultProperty": true } ]]
}
