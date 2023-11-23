#!/usr/bin/env bash

#	 @license:module:
#	 	MIT License
#
#	 	Copyright (c) 2023-present Richeve S. Bebedor <richeve.bebedor@gmail.com>
#
#	 	@license:copyright:
#	 		Richeve S. Bebedor
#
#	 		<@license:year-range:2023-present;>
#
#	 		<@license:contact-detail:richeve.bebedor@gmail.com;>
#	 	@license:copyright;
#
#	 	Permission is hereby granted, free of charge, to any person obtaining a copy
#	 	of this software and associated documentation files (the "Software"), to deal
#	 	in the Software without restriction, including without limitation the rights
#	 	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	 	copies of the Software, and to permit persons to whom the Software is
#	 	furnished to do so, subject to the following conditions:
#
#	 	The above copyright notice and this permission notice shall be included in all
#	 	copies or substantial portions of the Software.
#
#	 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	 	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	 	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	 	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#	 	SOFTWARE.
#	 @license:module;

set +o history;

SHELL_STATE="$(set +o)";

#; @todo-note: Modify parameter to include flow for optional and required.;
#; @todo-note: Modify to add fallback and handler for optional and required parameter.;

SHORT_PARAMETER_LIST=(	\
	h:					\
	v:					\
	n:					\
	l:					\
);

LONG_PARAMETER_LIST=(	\
	help:,				\
	version:,			\
	targetVersion:,		\
	npm:,				\
	targetNPMVersion:,	\
	local:,				\
	localSetupStatus:	\
);

SHORT_PARAMETER_LIST=$(echo $(IFS='';echo "${SHORT_PARAMETER_LIST[*]// /}";IFS=$' \t\n'));
LONG_PARAMETER_LIST=$(echo $(IFS='';echo "${LONG_PARAMETER_LIST[*]// /}";IFS=$' \t\n'));

PARAMETER="$(						\
getopt								\
--quiet								\
--alternative						\
--options $SHORT_PARAMETER_LIST		\
--longoptions $LONG_PARAMETER_LIST	\
-- "$@"								\
)";

[[ $? > 0 ]] &&	\
exit 1;

TARGET_VERSION=;
TARGET_NPM_VERSION=;
LOCAL_SETUP_STATUS=;

eval set -- "$PARAMETER";

while true;
do
	case "$1" in
		-h | --help )
			HELP_PROMPT_STATUS=true;
			shift 2
			;;
		-v | --version | --targetVersion )
			TARGET_VERSION=$2;
			shift 2
			;;
		-n | --npm | --targetNPMVersion )
			TARGET_NPM_VERSION=$2;
			shift 2
			;;
		-l | --local | --localSetupStatus )
			LOCAL_SETUP_STATUS=true;
			shift 2
			;;
		-- )
			shift;
			break
			;;
		* )
			break
			;;
	esac
done

set +vx; eval "$SHELL_STATE";

USER_HOME="$HOME";

[[ ! -z "$SUDO_USER" ]] &&	\
[[ "$HOME" == "/root" ]] &&	\
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6);

[[ -z "$PLATFORM_ROOT_DIRECTORY_PATH" ]] &&				\
[[ "$PLATFORM_ROOT_DIRECTORY_PATH" == "$PRDP" ]] &&		\
[[ "${PLATFORM_PARENT_DIRECTORY@a}" == *x* ]] &&		\
[[ ! -z "$PLATFORM_PARENT_DIRECTORY" ]] &&				\
PLATFORM_ROOT_DIRECTORY_PATH="$USER_HOME/$PLATFORM_PARENT_DIRECTORY";

[[ -z "$PLATFORM_ROOT_DIRECTORY_PATH" ]] &&				\
[[ "$PLATFORM_ROOT_DIRECTORY_PATH" == "$PRDP" ]] &&		\
[[ -z "$PLATFORM_PARENT_DIRECTORY" ]] &&				\
PLATFORM_ROOT_DIRECTORY_PATH="$USER_HOME";

PRDP="$PLATFORM_ROOT_DIRECTORY_PATH";

SYSTEM_TOOL_PATH=;

[[ "${SYSTEM_VALUE_NAMESPACE@a}" == *x* ]] &&	\
[[ ! -z "$SYSTEM_VALUE_NAMESPACE" ]] &&			\
SYSTEM_TOOL_PATH="$PRDP/$SYSTEM_VALUE_NAMESPACE-tool/tool";

[[ ! -x /usr/bin/curl ]] &&	\
sudo apt-get install curl --yes;

[[ -x /usr/bin/curl ]] &&	\
curl --version;

REPOSITORY_URI_PATH="https://raw.githubusercontent.com/volkovasystem/setup-nodejs-version/main";

[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
REPOSITORY_URI_PATH=$SYSTEM_TOOL_PATH;

if 												\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ -f "setup-jq.sh" ]] &&				\
		[[ ! -x $(which jq) ]]
	then
		source setup-jq.sh;
elif 											\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ ! -f "setup-jq.sh" ]] &&				\
		[[ -x $(which setup-jq)	]] &&			\
		[[ ! -x $(which jq)	]]
	then
		source setup-jq;
elif 											\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ ! -x $(which jq) ]]
	then
		source "$REPOSITORY_URI_PATH/setup-jq.sh";
elif 											\
		[[ "$LOCAL_SETUP_STATUS" != true ]] &&	\
		[[ ! -x $(which jq) ]]
	then
		source <(curl -fLqsS "$REPOSITORY_URI_PATH/setup-jq.sh");
else
		jq --version;
fi

if 												\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ -f "setup-wget.sh" ]] &&				\
		[[ ! -x $(which wget) ]]
	then
		source setup-wget.sh;
elif 											\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ ! -f "setup-wget.sh"	]] &&			\
		[[ -x $(which setup-wget) ]] &&			\
		[[ ! -x $(which wget) ]]
	then
		source setup-wget;
elif 											\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ ! -x $(which wget) ]]
	then
		source "$REPOSITORY_URI_PATH/setup-wget.sh";
elif 											\
	 	[[ "$LOCAL_SETUP_STATUS" != true ]] &&	\
		[[ ! -x $(which wget) ]]
	then
		source <(curl -fLqsS "$REPOSITORY_URI_PATH/setup-wget.sh");
else
		wget --version;
fi

if 																\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&					\
		[[ -f "setup-python-minimal.sh" ]] &&					\
		[[ ! -x $(which python2) ||	! -x $(which python3) ]]
	then
		source setup-python-minimal.sh;
elif 															\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&					\
		[[ ! -f "setup-python-minimal.sh" ]] && 				\
		[[ -x $(which setup-python-minimal) ]] &&				\
		[[ ! -x $(which python2) || ! -x $(which python3) ]]
	then
		source setup-python-minimal;
elif 															\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&					\
		[[ ! -x $(which python2) || ! -x $(which python3) ]]
	then
		source "$REPOSITORY_URI_PATH/setup-python-minimal.sh";
elif 															\
		[[ "$LOCAL_SETUP_STATUS" != true ]] &&					\
		[[ ! -x $(which python2) || ! -x $(which python3) ]]
	then
		source <(curl -fLqsS "$REPOSITORY_URI_PATH/setup-python-minimal.sh");
else
		python2 --version;
		python3 --version;
fi

if 												\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ -f "setup-tmux.sh" ]] &&				\
		[[ ! -x $(which tmux) ]]
	then
		source setup-tmux.sh;
elif 											\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ ! -f "setup-tmux.sh"	]] &&			\
		[[ -x $(which setup-tmux) ]] &&			\
		[[ ! -x $(which tmux) ]]
	then
		source setup-tmux;
elif 											\
		[[ "$LOCAL_SETUP_STATUS" = true ]] &&	\
		[[ ! -x $(which tmux) ]]
	then
		source "$REPOSITORY_URI_PATH/setup-tmux.sh";
elif 											\
	 	[[ "$LOCAL_SETUP_STATUS" != true ]] &&	\
		[[ ! -x $(which tmux) ]]
	then
		source <(curl -fLqsS "$REPOSITORY_URI_PATH/setup-tmux.sh");
else
		tmux -V;
fi

NODEJS_VERSION_PATH_NAMESPACE="nodejs-version";
NVPN=$NODEJS_VERSION_PATH_NAMESPACE;

NODEJS_VERSION_PATH="$PRDP/$NVPN";
NVP=$NODEJS_VERSION_PATH;

CURRENT_NODEJS_LTS_VERSION="$(								\
wget -qO- https://nodejs.org/download/release/index.json | 	\
jq '.[] | select(.lts!=false) | .version' | 				\
grep -Eo '[0-9]+.[0-9]+.[0-9]+'|							\
head -n 1)";

NODEJS_VERSION="$TARGET_VERSION";
[[ -z "$NODEJS_VERSION" ]] && \
NODEJS_VERSION=$CURRENT_NODEJS_LTS_VERSION;
NV=$NODEJS_VERSION;

NODEJS_PACKAGE_NAMESPACE="node-v$NV-linux-x64";
NPN=$NODEJS_PACKAGE_NAMESPACE;

NODEJS_DOWNLOAD_URL_PATH="https://nodejs.org/dist/v$NV/$NPN.tar.gz";
NDUP=$NODEJS_DOWNLOAD_URL_PATH;

NODEJS_PACKAGE_FILE_PATH="$NVP/$NPN.tar.gz";
NPFP=$NODEJS_PACKAGE_FILE_PATH;

NODEJS_PACKAGE_DIRECTORY_PATH="$NVP/$NPN";
NPDP=$NODEJS_PACKAGE_DIRECTORY_PATH;

[[ ! -d $NVP ]] && \
mkdir $NVP;

[[ ! -f $NPFP ]] && \
wget $NDUP -P $NVP;

[[ ! -d $NPDP ]] && \
tar -xzvf $NPFP -C $NVP;

NODEJS_PATH="$(			\
ls -d $NVP/$(ls $NVP |	\
grep $NV |				\
grep -v "\.tar\.gz$"	\
) 2>/dev/null)/bin";
NP=$NODEJS_PATH;

[[ $(echo $PATH | grep -oP $NVPN | head -1) == $NVPN ]] &&	\
export PATH="$(												\
echo $PATH |												\
tr ":" "\n" |												\
grep -v $NVPN |												\
tr "\n" ":" |												\
sed "s/:\{2,\}/:/g" |										\
sed "s/:$//")";

[[ $(echo $PATH | grep -oP $NP ) != $NP ]] &&	\
export PATH="$PATH:$NP";

npm config set update-notifier false --global 2> /dev/null;
npm config set fund false --global 2> /dev/null;

[[ -z "$TARGET_NPM_VERSION" ]] &&							\
(( $(($(npm --version | grep -Eo '^[0-9]+'))) <= 6 )) &&	\
TARGET_NPM_VERSION="6.14.18";

NPM_VERSION="$TARGET_NPM_VERSION";
[[ -z "$NPM_VERSION" ]] &&	\
NPM_VERSION="next-$(npm --version | grep -Eo '^[0-9]+')";

[[ $NPM_VERSION == "next" ]] &&	\
NPM_VERSION="next-$(npm --version | grep -Eo '^[0-9]+')";

NPMV=$NPM_VERSION;

(( $(($(npm --version | grep -Eo '^[0-9]+'))) > 6 )) &&	\
npm install npm@$NPMV --yes --global;

(( $(($(npm --version | grep -Eo '^[0-9]+'))) <= 6 )) &&	\
export npm_install=6.14.18 &&								\
curl -fLqsS https://raw.githubusercontent.com/npm/cli/v6.14.18/scripts/install.sh | bash;

[[ -x $(which python) ]] &&						\
[[ ! -x $(npm config get python --global) ]] &&	\
npm config set python=/usr/bin/python --global 2> /dev/null;

[[ -x $(which python2) ]] &&					\
[[ ! -x $(npm config get python --global) ]] &&	\
npm config set python=/usr/bin/python2 --global 2> /dev/null;

[[ -x $(which python3) ]] &&					\
[[ ! -x $(npm config get python --global) ]] &&	\
npm config set python=/usr/bin/python3 --global 2> /dev/null;

npm config set script-shell "/bin/bash";

[[ "$(which python2)" == "$(npm config get python --global)" ]] &&	\
echo "npm using python2";

[[ "$(which python3)" == "$(npm config get python --global)" ]] &&	\
echo "npm using python3";

echo "node@$(node --version)";
echo "npm@$(npm --version)";

[[ "$LOCAL_SETUP_STATUS" = true ]] &&		\
[[ ! -x $(which setup-nodejs-version) ]] &&	\
npm install @volkovasystem/setup-nodejs-version --yes --force --global;

set -o history;

[[ "$CONTAINER_CONTEXT_STATUS" != true ]] &&	\
[[ -n "$TMUX" ]] &&								\
history -c && bash -i;

[[ "$CONTAINER_CONTEXT_STATUS" != true ]] &&	\
[[ -z "$TMUX" ]] &&								\
history -c && bash -ic tmux new-session;
