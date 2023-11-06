#!/usr/bin/env bash

[[ -f "$MODULE_BUNDLE_SETTING_FILE_PATH" ]] &&	\
npm install --no-save webpack &&				\
npm install --no-save webpack-cli &&			\
npm link webpack &&								\
npm link webpack-cli &&							\
webpack build --config "$MODULE_BUNDLE_SETTING_FILE_PATH";
