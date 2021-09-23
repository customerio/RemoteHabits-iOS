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