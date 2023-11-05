#!/usr/bin/env bash

[[ ! -d "$MODULE_ROOT_DIRECTORY_PATH/.test" ]] &&	\
mkdir -p "$MODULE_ROOT_DIRECTORY_PATH/.test";

[[ -f "$MODULE_ROOT_DIRECTORY_PATH/$MODULE_NAMESPACE_VALUE.test.js" ]] &&	\
node "$MODULE_ROOT_DIRECTORY_PATH/$MODULE_NAMESPACE_VALUE.test.js";

[[ -d "$MODULE_ROOT_DIRECTORY_PATH/.test" ]] &&	\
rm -rfv "$MODULE_ROOT_DIRECTORY_PATH/.test";
