#! /usr/bin/env node

(
	async	function( ){
				const fs = require( "fs" );
				const path = require( "path" );

				const parseShellParameter = (
					require( "parse-shell-parameter" )
				);

				const fsAsync = (
					fs
					.promises
				);

				const MODULE_ROOT_DIRECTORY_PATH = (
						(
							process
							.env
							.MODULE_ROOT_DIRECTORY_PATH
						)
					||
						(
							__dirname
						)
				);

				const MODULE_NAMESPACE_VALUE = (
						(
							process
							.env
							.MODULE_NAMESPACE_VALUE
						)
					||
						(
							JSON
							.parse(
								(
									await	fsAsync
											.readFile(
												(
													path
													.resolve(
														(
															MODULE_ROOT_DIRECTORY_PATH
														),

														(
															"package.json"
														)
													)
												)
											)
								)
							)
							?.alias
						)
				);

				const MODULE_PATH = (
					`${ MODULE_ROOT_DIRECTORY_PATH }/${ MODULE_NAMESPACE_VALUE }.js`
				);

				const parameter = (
					parseShellParameter( )
				);

				const targetVersion = (
						(
							parameter
							.version
						)
					||
						(
							parameter
							.targetVersion
						)
					||
						(
							undefined
						)
				);

				const targetNPMVersion = (
						(
							parameter
							.npm
						)
					||
						(
							parameter
							.targetNPMVersion
						)
					||
						(
							undefined
						)
				);

				const localSetupStatus = (
						(
								(
										(
											/^true$/i
										)
										.test(
											(
												`${ parameter.local }`
											)
										)
									===	true
								)
						)
					?	(
							true
						)
					:	(
								(
										(
											/^false/i
										)
										.test(
											(
												`${ parameter.local }`
											)
										)
									===	true
								)
						)
					?	(
							false
						)
					:	(
								(
										(
											/^true$/i
										)
										.test(
											(
												`${ parameter.localSetupStatus }`
											)
										)
									===	true
								)
						)
					?	(
							true
						)
					:	(
								(
										(
											/^false/i
										)
										.test(
											(
												`${ parameter.localSetupStatus }`
											)
										)
									===	true
								)
						)
					?	(
							false
						)
					:	(
							undefined
						)
				);

				const contextNamespace = (
						(
							option
							.context
						)
					||
						(
							option
							.contextNamespace
						)
					||
						(
							undefined
						)
				);

				const directoryPath = (
						(
							option
							.directory
						)
					||
						(
							option
							.directoryPath
						)
					||
						(
							undefined
						)
				);

				const option = (
					{
						"targetVersion": (
							targetVersion
						),

						"targetNPMVersion": (
							targetNPMVersion
						),

						"localSetupStatus": (
							localSetupStatus
						),

						"contextNamespace": (
							contextNamespace
						),

						"directoryPath": (
							directoryPath
						),
					}
				);

				try{
					(
						await	require( `${ MODULE_PATH }` )(
									(
										option
									)
								)
					);
				}
				catch( error ){
					console.error(
						(
							[
								"#cannot-run-module;",

								"cannot run module;",

								"@parameter-data:",
								parameter,

								"@error-data:",
								error,
							]
						)
					);
				}
			}
)( );
