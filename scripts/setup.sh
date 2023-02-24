#!/usr/bin/env bash

set -eo pipefail

function main() {
	cat <<EOF
===============================================================================
RemoteHabits-iOS setup checklist

Follow the steps in to setup dev environment to be able to build and run the
RemoteHabits-iOS app in the Simulator or on a iPhone.
You can follow along and manually run all the steps, but some do offer you the
option to run the commands for you as well.
===============================================================================
EOF

	step 'Install Xcode from the App Store or the Self Service app'
	
	step 'Set xcode command line tools
- Open Xcode
- In the menu bar select Xcode -> Settings
- Go to the Locations tab
- Ensure Command Line Tools are set under the dropdown
	- If it mentions "No Xcode Selected" just pick the latest version from the dropdown
https://stackoverflow.com/questions/50404109/unable-to-locate-xcode-please-make-sure-to-have-xcode-installed-on-your-machine/51246596#51246596'

	step 'Clone the "RemoteHabits-iOS" repository by running:
	git clone git@github.com:customerio/RemoteHabits-iOS.git' run_clone_repo

	step 'Navigate into the "RemoteHabits-iOS" repository'

	step 'Install/Switch to ruby version specified in the .ruby-version file.
Syntax depends on the version manager tool you are using.
Some tools: rbenv, rvm, chruby, asdf, rtx, frum'

	step 'Install bundler tool to manage ruby gems for project by running:
	gem install bundler' run_install_bundler

	step 'Use bundler to install tools for the project by running:
	bundle install' run_install_gems

	step 'Download google credentials and save it.
- Open 1Password
- Search for "gc_keys.json"
- Download the file and save to easily referenced location (eg. ~/code/dev-creds/gc_keys.json)'

	step 'Set environment variable to the saved credential file by running:
	export FASTLANE_GC_KEYS_FILE=[path to file from previous step] ex.
	export FASTLANE_GC_KEYS_FILE=~/code/dev-creds/gc_keys.json
You can also save this in your ~/.zshrc file so that you do not need to set it again.'

	step 'Install certificates & profiles for development by running:
	bundle exec fastlane ios dev_setup' run_fastlane_setup

	step 'Copy sample env file by running:
	cp "Remote Habits/Env.swift.example" "Remote Habits/Env.swift"' run_copy_env_file

	step 'Build app
- Open Xcode
- Choose Open a project
- Navigate and select the RemoteHabits-iOS directory
- Xcode tries to download the dependencies and may ask to "Trust" connection to github
- Choose iOS Simulator or iPhone target
- Press "Play" button to build app and launch on selected target
	- If you get build errors try "File -> Packages -> Reset Package Caches" and try again'
}

# automated run functions to run the specified step

function run_clone_repo() {
	read -p "Directory where the repository should be cloned to: " dir
	if [[ ! -d "$dir" ]]; then
		echo "The directory $dir does not exist."
		exit 1
	fi

	repo_dir="$dir/RemoteHabits-iOS"
	if [[ ! -d "$repo_dir" ]] ; then
	  git clone git@github.com:customerio/RemoteHabits-iOS.git $repo_dir
	fi
}

function run_install_bundler() {
	check_ruby_version
	gem install bundler
}

function run_install_gems() {
	check_ruby_version

	if [[ ! -f "$repo_dir/Gemfile" ]]; then
		echo "Missing Gemfile recheck path to repository."
		exit 1
	fi

	bundle install
}

function run_fastlane_setup() {
	check_ruby_version

	if [[ -z "$FASTLANE_GC_KEYS_FILE" ]]; then
		read -p "Path to the gc_keys.json file: " keys_file
		export FASTLANE_GC_KEYS_FILE=$keys_file
	fi

	bundle exec fastlane ios dev_setup
}

function run_copy_env_file() {
	set_repo_dir
	cd $repo_dir

	if [[ ! -f "Remote Habits/Env.swift" ]] ; then
	  cp "Remote Habits/Env.swift.example" "Remote Habits/Env.swift"
	fi
}

# helper functions

# helper utility to check ruby version matches from .ruby-version file.
# 
function check_ruby_version() {
	set_repo_dir

	cd $repo_dir

	if ! ruby -v | grep -q $(cat .ruby-version); then
		echo "Detected different ruby version
	got: $(ruby -v)
	expected: $(cat .ruby-version)
May need to switch to the ruby version in the shell and rerun this script."
		exit 1
	fi
}


# helper utility to check if repo_dir variable exists or prompt for it.
# 
function set_repo_dir() {
	if [[ ! -d "$repo_dir" ]]; then
		read -p "Path to the repository: " repo_dir
	fi

	if [[ ! -d "$repo_dir" ]] ; then
		echo "Repository not found."
		exit 1
	fi
}


# helper utility to print the step and handle the user input.
# params:
# 	$1 - description of the step
# 	$2 - function to call if step can be run within the script if user opts for it
# 
function step() {
	((step_idx++))
	cat <<EOF

Step $step_idx: $1

EOF

	handle_input $2
}

# helper utility to ask for user input.
# params:
# 	$1 - if provided enables run option and calls function if selected
# 
function handle_input() {
	local prompt=''
	if [[ -n $1 ]]; then
		while true; do
			read -p "Choose [c]ontinue, [q]uit or [r]un: " answer
			case $answer in
				[Qq]* ) exit 0 ;;
				[Cc]* ) break ;;
				[Rr]* ) $1 && break ;;
			esac
		done
	else
		while true; do
			read -p "Choose [c]ontinue or [q]uit: " answer
			case $answer in
				[Qq]* ) exit 0 ;;
				[Cc]* ) break ;;
			esac
		done
	fi
}

main "$@"
