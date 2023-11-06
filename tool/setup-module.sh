#!/usr/bin/env bash

[[ -f "$MODULE_SETUP_LIST_FILE_PATH" ]] &&	\
cat "$MODULE_SETUP_LIST_FILE_PATH" | xargs -n1 -I {} bash -c "{}";

[[ -f "$MODULE_DEPENDENCY_LIST_FILE_PATH" ]] &&	\
[[ -f "$MODULE_PACKAGE_FILE_PATH" ]] &&			\
cp "$MODULE_PACKAGE_FILE_PATH" "$MODULE_PACKAGE_FILE_PATH.backup";

[[ -f "$MODULE_DEPENDENCY_LIST_FILE_PATH" ]] &&	\
cat "$MODULE_DEPENDENCY_LIST_FILE_PATH" | xargs -n1 -I {} bash -c "npm install {}";

[[ -f "$MODULE_PACKAGE_FILE_PATH.backup" ]] &&	\
mv --force "$MODULE_PACKAGE_FILE_PATH.backup" "$MODULE_PACKAGE_FILE_PATH";

[[ -d "$TRASH_DIRECTORY" ]] &&					\
[[ -f "$MODULE_PACKAGE_LOCK_FILE_PATH" ]] &&	\
mv --force "$MODULE_PACKAGE_LOCK_FILE_PATH" "$TRASH_DIRECTORY";

return 0;
