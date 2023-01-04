#!/usr/bin/env bash

set +o history;

SHELL_STATE="$(set +o)";

set \
-o noclobber \
-o nounset \
-o pipefail;

PARAMETER="$(\
getopt \
--quiet \
--alternative \
--options v:n: \
--longoptions version:,npm: \
-- "$@"\
)";

[[ $? > 0 ]] && \
exit 1;

TARGET_VERSION=;
TARGET_NPM_VERSION=;

eval set -- "$PARAMETER";

while true;
do
	case "$1" in
		-v | --version )
			TARGET_VERSION=$2;
			shift 2
			;;
		-n | --npm )
			TARGET_NPM_VERSION=$2;
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

#;	@section: setup nodejs version:

#;	@section: install needed module;
[[ ! -x /usr/bin/curl ]] && \
sudo apt-get install -y curl;

curl --version;

REPOSITORY_URI_PATH="https://raw.githubusercontent.com/volkovasystem/setup-nodejs-version/main";

if 		[[ 								\
				-f "setup-jq.sh"		\
			&&							\
				! -x $(which jq) 		\
		]]
	then
		source setup-jq.sh;
elif 	[[ 								\
				! -f "setup-jq.sh"		\
			&&							\
				-x $(which setup-jq)	\
			&&							\
				! -x $(which jq)		\
		]]
	then
		source setup-jq;
elif [[ ! -x $(which jq) ]]
	then
		source <(curl -sqL "$REPOSITORY_URI_PATH/setup-jq.sh");
else
		jq --version;
fi

if [[ -f "setup-wget.sh" && ! -x $(which wget) ]]
	then
		source setup-wget.sh;
elif [[ ! -f "setup-wget.sh" && -x $(which setup-wget) && ! -x $(which wget) ]]
	then
		source setup-wget;
elif [[ ! -x $(which wget) ]]
	then
		source <(curl -sqL "$REPOSITORY_URI_PATH/setup-wget.sh");
else
		wget --version;
fi

if [[ -f "setup-python-minimal.sh" && ( ! -x $(which python2) || ! -x $(which python3) ) ]]
	then
		source setup-python-minimal.sh;
elif [[ ! -f "setup-python-minimal.sh" && -x $(which setup-python-minimal) && ( ! -x $(which python2) || ! -x $(which python3) ) ]]
	then
		source setup-python-minimal;
elif [[ ! -x $(which python2) || ! -x $(which python3) ]]
	then
		source <(curl -sqL "$REPOSITORY_URI_PATH/setup-python-minimal.sh");
else
		python2 --version;
		python3 --version;
fi

PLATFORM_ROOT_DIRECTORY_PATH="";
PRDP=""

#;	@section: set platform root directory;
[[ -z "$PLATFORM_ROOT_DIRECTORY_PATH" ]] && \
[[ $PLATFORM_ROOT_DIRECTORY_PATH == $PRDP ]] && \
PLATFORM_ROOT_DIRECTORY_PATH=$HOME;
PRDP=$PLATFORM_ROOT_DIRECTORY_PATH;

#;	@note: set nodejs version path namespace;
NODEJS_VERSION_PATH_NAMESPACE="nodejs-version";
NVPN=$NODEJS_VERSION_PATH_NAMESPACE;

#;	@note: set nodejs version path;
NODEJS_VERSION_PATH="$PRDP/$NVPN";
NVP=$NODEJS_VERSION_PATH;

#;	@note: set nodejs version;
CURRENT_NODEJS_LTS_VERSION="$(\
wget -qO- https://nodejs.org/download/release/index.json | \
jq '.[] | select(.lts!=false) | .version' | \
grep -Eo '[0-9]+.[0-9]+.[0-9]+'| \
head -n 1)";
NODEJS_VERSION="$TARGET_VERSION";
[[ -z "$NODEJS_VERSION" ]] && \
NODEJS_VERSION=$CURRENT_NODEJS_LTS_VERSION;
NV=$NODEJS_VERSION;

#;	@note: set nodejs package namespace;
NODEJS_PACKAGE_NAMESPACE="node-v$NV-linux-x64";
NPN=$NODEJS_PACKAGE_NAMESPACE;

#;	@note: set nodejs download URL path;
NODEJS_DOWNLOAD_URL_PATH="https://nodejs.org/dist/v$NV/$NPN.tar.gz";
NDUP=$NODEJS_DOWNLOAD_URL_PATH;

#;	@note: set nodejs package file path;
NODEJS_PACKAGE_FILE_PATH="$NVP/$NPN.tar.gz";
NPFP=$NODEJS_PACKAGE_FILE_PATH;

#;	@note: set nodejs package directory path;
NODEJS_PACKAGE_DIRECTORY_PATH="$NVP/$NPN";
NPDP=$NODEJS_PACKAGE_DIRECTORY_PATH;

#;	@note: initialize nodejs version directory;
[[ ! -d $NVP ]] && \
mkdir $NVP;

#;	@note: download nodejs package;
[[ ! -f $NPFP ]] && \
wget $NDUP -P $NVP;

#;	@note: extract nodejs package;
[[ ! -d $NPDP ]] && \
tar -xzvf $NPFP -C $NVP;

#;	@note: set nodejs path;
NODEJS_PATH="$(\
ls -d $NVP/$(ls $NVP | \
grep $NV | \
grep -v "\.tar\.gz$"\
) 2>/dev/null)/bin";
NP=$NODEJS_PATH;

#;	@note: clean nodejs binary path;
[[ $(echo $PATH | grep -oP $NVPN | head -1) == $NVPN ]] && \
export PATH="$(\
echo $PATH | \
tr ":" "\n" | \
grep -v $NVPN | \
tr "\n" ":" | \
sed "s/:\{2,\}/:/g" | \
sed "s/:$//")";

#;	@note: export nodejs binary path;
[[ $(echo $PATH | grep -oP $NP ) != $NP ]] && \
export PATH="$PATH:$NP";

npm config set update-notifier false --global 2> /dev/null;
npm config set fund false --global 2> /dev/null;

#;	@note: update npm;
[[ -z "$TARGET_NPM_VERSION" ]] && \
(( $(($(npm --version | grep -o '^[0-9]'))) < 6 )) && \
TARGET_NPM_VERSION="6.14.18";

NPM_VERSION="$TARGET_NPM_VERSION";
[[ -z "$NPM_VERSION" ]] && \
NPM_VERSION="next-$(npm --version | grep -o '^[0-9]')";

[[ $NPM_VERSION == "next" ]] && \
NPM_VERSION="next-$(npm --version | grep -o '^[0-9]')";

(( $(($(echo $NPM_VERSION | grep -o '[0-9]'))) < 6 )) && \
NPM_VERSION="next-6";

NPMV=$NPM_VERSION;

(( $(($(npm --version | grep -o '^[0-9]'))) >= 6 )) && \
npm install npm@$NPMV --global;

(( $(($(npm --version | grep -o '^[0-9]'))) < 6 )) && \
export npm_install=6.14.18 && curl -sqL https://www.npmjs.com/install.sh | bash;

#;	@note: set npm python path.
[[ -x $(which python) && ! -x $(npm config get python --global) ]] && \
npm config set python=/usr/bin/python --global 2> /dev/null;

#;	@note: set npm python path.
[[ -x $(which python2) && ! -x $(npm config get python --global) ]] && \
npm config set python=/usr/bin/python2 --global 2> /dev/null;

#;	@note: set npm python path.
[[ -x $(which python3) && ! -x $(npm config get python --global) ]] && \
npm config set python=/usr/bin/python3 --global 2> /dev/null;

[[ "$(which python2)" == "$(npm config get python --global)" ]] && \
echo "npm using python2";

[[ "$(which python3)" == "$(npm config get python --global)" ]] && \
echo "npm using python3";

echo "node@$(node --version)";
echo "npm@$(npm --version)";

[[ ! -x $(which setup-nodejs-version) ]] && \
npm install @volkovasystem/setup-nodejs-version --global;

#;	@section: setup nodejs version;

set -o history;

exec $SHELL -i;
