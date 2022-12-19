#!/usr/bin/env bash

#;	@section: setup python minimal:

#;	@note: install python minimal;
[[ ! -x /usr/bin/python2 || ! -x /usr/bin/python3 ]] &&\
sudo apt-get install -y python*-minimal;

#;	@section: setup python minimal;
