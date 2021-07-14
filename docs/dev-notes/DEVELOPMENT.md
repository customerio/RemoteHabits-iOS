# Development 

Here is how to get started with the project. Get yourself a development environment setup. 

1. The app opens up in XCode. However, you need to setup code signing. 

* If you are *not* a Customer.io developer, modify the code signing in XCode to your own provisioning profile. 
* If you *are* a Customer.io developer, you will need to download to already created provisioning profile to your machine. Follow the instructions in this document to setup code signing. 

2. Setup git hooks to lint your code for you:

```
$ ./hooks/autohook.sh install
[Autohook] Scripts installed into .git/hooks
```

After you run this command above, you will see a message about a few different CLI tools to install on your machine. Follow those instructions to install the tools. 

# Setup code signing (internal team member)

1. Download the file `gc_keys.json` from 1Password. Download this file to the root directory of the Remote Habits iOS source code. 
2. Install the CLI tool [fastlane](https://docs.fastlane.tools/getting-started/ios/setup/#installing-fastlane) to your computer. The `gem install` method is the recommended way but other ways may work just fine, too. 
3. Run `fastlane match` in the root directory of the Remote Habits iOS source code. Fastlane should *not* ask you to login to your Apple or Google account. Instead, it should simply download the provisioning profile and certificates and give you a success message:

![if running fastlane match is successful, you should receive a message "All required keys, certificates, and provisioning profiles are installed"](img/fastlane_match_successs.png)

Done! Now, exit and reopen the project in XCode. Then check to make sure there are no errors in the code signing section.

![Check xcode > project settings > signing and capabilities > signing certificate does now have any errors and instead has a name of the certificate listed](img/check_errors_signing_xcode.png)