# Development 

Here is how to get started with the project. Get yourself a development environment setup. 

1. The app opens up in XCode. However, you need to setup code signing. 

* If you are *not* a Customer.io developer, modify the code signing in XCode to your own provisioning profile. 
* If you *are* a Customer.io developer, you will need to download to already created provisioning profile to your machine. Follow the instructions documented in the internal documentation for Remote Habits iOS development setup. 

2. Setup git hooks to lint your code for you:

```
$ ./hooks/autohook.sh install
[Autohook] Scripts installed into .git/hooks
```

After you run this command above, you will see a message about a few different CLI tools to install on your machine. Follow those instructions to install the tools. 