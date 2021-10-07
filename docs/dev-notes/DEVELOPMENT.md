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

3. You need to authenticate with the Customer.io SDK. Run `cp "Remote Habits/Env.swift.example" "Remote Habits/Env.swift"` and then modify the values in the `Remote Habits/Env.swift` file with credentials for a Customer.io Workspace you want to send data to. This file is ignored for git so don't worry about sharing your keys.  

# Setup code signing (internal team member)

1. Download the file `gc_keys.json` from 1Password. Download this file to the root directory of the Remote Habits iOS source code. 
2. Install the CLI tool [fastlane](https://docs.fastlane.tools/getting-started/ios/setup/#installing-fastlane) to your computer. The `gem install` method is the recommended way but other ways may work just fine, too. 
3. Run `fastlane match` in the root directory of the Remote Habits iOS source code. Fastlane should *not* ask you to login to your Apple or Google account. Instead, it should simply download the provisioning profile and certificates and give you a success message:

![if running fastlane match is successful, you should receive a message "All required keys, certificates, and provisioning profiles are installed"](img/fastlane_match_successs.png)

Done! Now, exit and reopen the project in XCode. Then check to make sure there are no errors in the code signing section.

![Check xcode > project settings > signing and capabilities > signing certificate does now have any errors and instead has a name of the certificate listed](img/check_errors_signing_xcode.png)

# Test push notifications 

Testing rich push notifications can be difficult. Hopefully this doc is a good starting point to do so. 

* Run app in XCode in debug on a test device. 
* Send yourself a push notification. Your breakpoints will not trigger yet and that's ok. This first time you send yourself a push is just to "wake up" the Notification Service target in the project. 

The push JSON content matters. It must contain this content at a minimum or your Notification Service will not be executed:

```json
{
    "aps": {
        "mutable-content": 1,
        "alert": {
            "title": "foo",
            "body": "message here"
        }
    }
}
```

* In XCode, select `Debug > Attach to process > Notification Service`. Notification Service should be at the top of the list. If it's not, confirm that a push notification successfully got sent because it could mean that none of the code in your Notification Service got executed. 
* Now your XCode debugger is connected to the app *and* the notification service you made. Great!
* Now, set breakpoints in the app and/or the SDK. Breakpoints work better then print statements I have found. I have not been able to see print statements in the console for code in the SDK. 
* Send yourself a push again. This time your breakpoints should trigger. 

# Test FCM push

The Remote Habits app is setup to only work with APN at this time. You must follow these special instructions to get FCM push working with the app:

1. Install the FCM SDK module. 
![Install the swift package Firebase Messaging framework into your project via XCode target settings](img/xcode_add_fcm_messaging.jpeg)

2. Open the file `AppDelegateFCM` and uncomment the file. It is commented out because the FCM SDK is uninstalled by default. 

3. Open the file `RemoteHabitsApp` and follow the instructions for enabling FCM's AppDelegate. 

4. If you have the Remote Habits app installed on your device right now using APN, you should delete the app and re-install this FCM build. 
