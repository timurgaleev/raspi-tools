#!/bin/bash

curl 'https://api.ipify.org?format=json'
ip addr | grep 'inet ' | grep '/24 '
