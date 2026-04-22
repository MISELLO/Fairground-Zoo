#!/bin/bash

# This script shows style suggestions on your go code.

clear
date +***\ %d-%m-%Y\ %H:%M:%S\ ***
echo "*** gocyclo -over 15 ***"
gocyclo -over 15 .
echo "*** goimports -d ***"
goimports -d .
echo "*** misspell ***"
misspell .
echo "*** shadow ***"
find . -name "*.go" -exec shadow {} \;
echo "*** golint ***"
golint .
echo "*** go fix ***"
find . -name "*.go" -exec go fix --diff {} \;

#golangci-lint run main.go
