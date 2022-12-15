#!/usr/bin/env bash

#;	@section: setup nodejs version:

#;	@section: install needed module;
[[ ! -x $(which jq) ]] &&\
sudo apt-get install jq;

#;	@section: set platform root directory;
[[ -z "$PLATFORM_ROOT_DIRECTORY_PATH" ]] &&\
[[ $PLATFORM_ROOT_DIRECTORY_PATH == $PRDP ]] &&\
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
NODEJS_VERSION="$1";
[[ -z "$NODEJS_VERSION" ]] &&\
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
[[ ! -d $NVP ]] &&\
mkdir $NVP;

#;	@note: download nodejs package;
[[ ! -f $NPFP ]] &&\
wget $NDUP -P $NVP;

#;	@note: extract nodejs package;
[[ ! -d $NPDP ]] &&\
tar -xzvf $NPFP -C $NVP;

#;	@note: set nodejs path;
NODEJS_PATH="$(\
ls -d $NVP/$(ls $NVP | \
grep $NV | \
grep -v "\.tar\.gz$"\
) 2>/dev/null)/bin";
NP=$NODEJS_PATH;

#;	@note: clean nodejs binary path;
[[ $(echo $PATH | grep -oP $NVPN | head -1) == $NVPN ]] &&\
export PATH="$(\
echo $PATH | \
tr ":" "\n" | \
grep -v $NVPN | \
tr "\n" ":" | \
sed "s/:\{2,\}/:/g" | \
sed "s/:$//")";

#;	@note: export nodejs binary path;
[[ $(echo $PATH | grep -oP $NP ) != $NP ]] &&\
export PATH="$PATH:$NP";

#;	@note: update npm;
NPM_VERSION="$2";
[[ -z "$NPM_VERSION" ]] &&\
NPM_VERSION="latest";

[[ $NPM_VERSION == "next" ]] &&\
NPM_VERSION="next-$(npm --version | grep -o '^[0-9]')" ;

NPMV=$NPM_VERSION;
npm install npm@$NPMV --global;

#;	@note: set npm python path.
[[ -x /usr/bin/python ]] &&\
npm config set python /usr/bin/python;

#;	@note: set npm python path.
[[ -x /usr/bin/python3 ]] &&\
npm config set python /usr/bin/python3;

#;	@note: set npm python path.
[[ -x /usr/bin/python2 ]] &&\
npm config set python /usr/bin/python2;

#;	@note: set npm binary directory path.
export NPM_BINARY_DIRECTORY_PATH="$(npm bin --global)";
export NBDP=$NPM_BINARY_DIRECTORY_PATH;

#;	@section: setup nodejs version;
