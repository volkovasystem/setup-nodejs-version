#!/usr/bin/env bash

[[ -f "$MODULE_ROOT_DIRECTORY_PATH/.build/$MODULE_NAMESPACE_VALUE.bundle.js" ]] &&	\
npx --yes --ignore-existing															\
terser "$MODULE_ROOT_DIRECTORY_PATH/.build/$MODULE_NAMESPACE_VALUE.bundle.js"		\
--compress defaults=false,dead_code=false,side_effects=false,unused=false			\
--keep-classnames																	\
--keep-fnames																		\
--comments '/^\;\!/'																\
--output "$MODULE_ROOT_DIRECTORY_PATH/.build/$MODULE_NAMESPACE_VALUE.js";
