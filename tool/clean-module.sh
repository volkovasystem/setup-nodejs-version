#!/usr/bin/env bash

rm -rf "$MODULE_ROOT_DIRECTORY_PATH/node_modules" || true &&		\
rm -fv "$MODULE_ROOT_DIRECTORY_PATH/package-lock.json" || true &&	\
npm cache clean --force --loglevel=error;
