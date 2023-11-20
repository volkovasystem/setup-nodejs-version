"use strict";

/*;!
	@license:module:
		MIT License

		Copyright (c) 2023-present Richeve S. Bebedor <richeve.bebedor@gmail.com>

		@license:copyright:
			Richeve S. Bebedor

			<@license:year-range:2023-present;>

			<@license:contact-detail:richeve.bebedor@gmail.com;>
		@license:copyright;

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	@license:module;
*/

const setupNodeJSVersion = (
	async	function setupNodeJSVersion( option ){
				const childProcess = require( "child_process" );
				const fs = require( "fs" );
				const path = require( "path" );
				const util = require( "util" );

				const fsAsync = (
					fs
					.promises
				);

				const execAsync = (
					util
					.promisify(
						(
							childProcess
							.exec
						)
					)
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
									/*;
										@todo:
											Wrap this inside try-catch block
											with proper error handling.
										@todo;
									*/
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

				const SETUP_NODEJS_VERSION_SCRIPT_PATH = (
					path
					.resolve(
						(
							MODULE_ROOT_DIRECTORY_PATH
						),

						(
							`${ MODULE_NAMESPACE_VALUE }.sh`
						)
					)
				);

				const targetVersion = (
						(
							option
							.targetVersion
						)
					||
						(
							undefined
						)
				);

				const targetNPMVersion = (
						(
							option
							.targetNPMVersion
						)
					||
						(
							undefined
						)
				);

				const localSetupStatus = (
						(
							option
							.localSetupStatus
						)
					||
						(
							undefined
						)
				);

				const SETUP_COMMAND = (
					(
						[
							(
								SETUP_NODEJS_VERSION_SCRIPT_PATH
							),

							(
									(
											(
													typeof
													targetVersion
												!=	"undefined"
											)
									)
								?	(
										`--version ${ targetVersion }`
									)
								:	(
										undefined
									)
							),

							(
									(
											(
													typeof
													targetNPMVersion
												!=	"undefined"
											)
									)
								?	(
										`--npm ${ targetNPMVersion }`
									)
								:	(
										undefined
									)
							),

							(
									(
											(
													typeof
													localSetupStatus
												==	"boolean"
											)
									)
								?	(
										`--local ${ localSetupStatus }`
									)
								:	(
										undefined
									)
							),
						]
					)
					.filter( Boolean )
					.join( " " )
				);

				try{
					(
						await	execAsync(
									(
										`bash -c ${ SETUP_COMMAND }`
									)
								)
					);
				}
				catch( error ){
					console.error(
						(
							[
								"#cannot-run-setup-nodejs-version;",

								"cannot run setup nodejs version;",

								"@option-data:",
								option,

								"@error-data:",
								error,
							]
						)
					);
				}
			}
);

(
		module
		.exports
	=	(
			setupNodeJSVersion
		)
);
