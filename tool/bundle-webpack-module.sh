#!/usr/bin/env bash

npm install --no-save webpack-cli;

npx --yes webpack build --config "$MODULE_ROOT_DIRECTORY_PATH/setting/bundle-configure.js";
