#!/usr/bin/env bash

[[ ! -d "$MODULE_ROOT_DIRECTORY_PATH/.build" ]] &&	\
mkdir -p "$MODULE_ROOT_DIRECTORY_PATH/.build";

npm run bundle-module &&	\
npm run compress-module &&	\
npm run resolve-module;

return 0;
