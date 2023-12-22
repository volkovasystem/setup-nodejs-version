#	setup-nodejs-version

##	Setup NodeJS Version

### Parameter
* `-v | --version | --targetVersion`
* `-n | --npm | --targetNPMVersion`

###	Usage

* Default setup via source-curl
```bash
source <(curl -fLqsS https://raw.githubusercontent.com/volkovasystem/setup-nodejs-version/main/setup-nodejs-version.sh?$RANDOM)
```

* Install locally using latest LTS version via source-curl
```bash
source <(curl -fLqsS https://raw.githubusercontent.com/volkovasystem/setup-nodejs-version/main/setup-nodejs-version.sh?$RANDOM) --local true
```

* Change version via source-curl
```bash
source <(curl -fLqsS https://raw.githubusercontent.com/volkovasystem/setup-nodejs-version/main/setup-nodejs-version.sh?$RANDOM) -v 18.18.2
```

* Default setup via npx
```bash
npx @volkovasystem/setup-nodejs-version
```

* Change version via npx
```bash
npx @volkovasystem/setup-nodejs-version --version 18.18.2
```

* Default setup via npm global
```bash
npm install @volkovasystem/setup-nodejs-version --global
```

* Change version via installed global module
```bash
setup-nodejs-version --targetVersion 18.18.2
```

###	Supported OS Platform

* Ubuntu 20.04.x LTS
