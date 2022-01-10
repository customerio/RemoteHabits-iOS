#!/bin/sh 

set -e 

# Script that asserts that lint checks were executed and fixed on the developer's local development machine 
# before pushing up code. 

RED='\033[0;31m'
NO_COLOR='\033[0m'

ERROR_MESSAGE="${RED}ERROR: It looks like there are lint errors. To fix this error, run \"make lint\" on your local machine, fix all lint errors that popup, make a git commit, then push up your code to GitHub. \nYou can install git hooks to run \"make lint\" for you automatically: https://github.com/customerio/RemoteHabits-iOS/blob/main/docs/dev-notes/DEVELOPMENT.md ${NO_COLOR}"

# Below will run a lint check and then will check if any files were edited. 
# If files were changed, that means that the swift code formatter tool made changes. 
# If either of these commands fail, that means that "make lint" was not executed and/or lint errors were not fixed on the local development machine before pushing code up to GitHub. 
# We print an error message if either of the 2 commands fail. 

(make lint && git diff --exit-code > /dev/null) || printf "${ERROR_MESSAGE}"