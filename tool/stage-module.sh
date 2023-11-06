#!/usr/bin/env bash

npm cache clean --force --loglevel=error;

[[ -f "$MODULE_ROOT_DIRECTORY_PATH/tool/transform-context-module.sh" ]] &&	\
npm run transform-context-module;

npx --yes --ignore-existing @volkovasystem/format-package-json-file;

npm run reset-module &&	\
npm run setup-module &&	\
npm run build-module &&	\
npm run test-module &&	\
npm run clean-module;

[[ -f "$MODULE_ROOT_DIRECTORY_PATH/tool/reset-context-module.sh" ]] &&	\
npm run reset-context-module;

return 0;
