#!/usr/bin/env bash

npx --yes @volkovasystem/format-package-json-file;

npm run reset-module &&	\
npm run setup-module &&	\
npm run build-module &&	\
npm run test-module &&	\
npm run clean-module;
