#!/usr/bin/env bash

npm run clean &&																\
rm -rfv "$MODULE_ROOT_DIRECTORY_PATH/$MODULE_NAMESPACE_VALUE.js" || true &&		\
rm -rfv "$MODULE_ROOT_DIRECTORY_PATH/.build" || true && 						\
rm -rfv "$MODULE_ROOT_DIRECTORY_PATH/.test" || true;
