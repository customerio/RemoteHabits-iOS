SHELL = /bin/sh

generate:
	sourcery --sources "Remote Habits" --templates "Remote Habits/Templates" --output "Remote Habits/autogenerated" --args imports=CioTracking-CioMessagingPushAPN

lint:
	(make format && swiftlint lint --strict) || printf "\n-----------------------------------------\n ERROR: Fix all lint errors above, commit, then push code again. \n-----------------------------------------"

# specify swiftversion this way instead of .swift-version to (1) keep project files slim and (2) we can specify the version in a CI server matrix for multiple version testing. 
# use the min Swift version that we support/test against. 
format:
	swiftformat . --swiftversion 5.3 && swiftlint lint --fix