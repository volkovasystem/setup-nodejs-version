"use strict";

const BUNDLE_CONFIGURE = (
	{
		"entry": (
			[
				`${ process.env.MODULE_ROOT_DIRECTORY_PATH }/${ process.env.MODULE_NAMESPACE_VALUE }.module.js`
			]
		),

		"mode": (
			"production"
		),

		"output": (
			{
				"filename": (
					`${ process.env.MODULE_NAMESPACE_VALUE }.bundle.js`
				),

				"path": (
					`${ process.env.MODULE_ROOT_DIRECTORY_PATH }/.build`
				),

				"library": (
					{
						"name": (
							`${ process.env.MODULE_NAMESPACE_VARIABLE }`
						),

						"type": (
							"umd"
						),

						"umdNamedDefine": (
							true
						),
					}
				),

				"globalObject": (
					"this"
				),
			}
		),

		"optimization": (
			{
				"minimize": false,
			}
		),
	}
);

(
		module
		.exports
	=	(
			BUNDLE_CONFIGURE
		)
);
