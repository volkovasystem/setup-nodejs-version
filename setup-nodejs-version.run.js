#! /usr/bin/env node

(
	async	function( ){
				const MODULE_ROOT_DIRECTORY_PATH = (
					process.env.MODULE_ROOT_DIRECTORY_PATH
				);

				const MODULE_NAMESPACE_VALUE = (
					process.env.MODULE_NAMESPACE_VALUE
				);

				const parseShellParameter = (
					require( "parse-shell-parameter" )
				);

				const parameter = (
					parseShellParameter( )
				);

				try{


					const option = (
						{

						}
					);

					await require( `${ MODULE_ROOT_DIRECTORY_PATH }/${ MODULE_NAMESPACE_VALUE }.js` )( option );
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
