# Deployment 

Here are instructions for CI setup. 

* Create Service Accounts to authenticate CI server with Firebase. 

To create Service Accounts, go to Firebase project > Settings > Service accounts > Click on "X service accounts from Google Cloud Platform. It opens up Google Cloud Platform webpage for you. Your Firebase project should be selected as the Google Cloud project when this webpage is opened. This is because when you have a Firebase project, a Google Cloud project gets created for you without you even knowing it.

Create 2 service accounts:
1. `firebase app distribution` with permissions `Firebase App Distribution Admin`

For both of these service accounts, create a private key file. Do this by clicking "Add key" > JSON under the service account you just created. Save this file to the tmp directory of your computer. 

* Run `cat /tmp/service-account-file-you-just-downloaded.json | base64` for both of the private keys that you downloaded. The strings printed to you are going to be used soon. Keep them handy. 

* Set the following secret environment variables:

1. `ENV_FILE_B64` - base64 encoded contents of `Env.swift` source code file which defines values needed for the app. Run `cat "Remote Habits/Env.swift" | base64`. The output is the value for this secret. 
3. `FIREBASE_PROJECT_ID` - Firebase project for app. Find in firebase project settings > General tab. 
4. `REPO_PUSH_TOKEN` - personal github token to push to the repo. Make sure the github username for this token has push permissions for this repo. 
6. `FIREBASE_APP_DISTRIBUTION_GOOGLE_AUTH` - base64 encoded string of the Firebase App Distribution Service Account private file you downloaded. 
7. `FIREBASE_APP_ID` - App ID for the app in your Firebase project. Find in firebase project settings > General tab > apps > select your app > app id. Format is similar to: `"1:1234567890:ios:0a1b2c3d4e5f67890"`
8. `APP_STORE_CONNECT_API_KEY_ID` - the key id for App Store Connect API key. 
9. `APP_STORE_CONNECT_API_ISSUER_ID` - the issuer id for App Store Connect API key.
10. `APP_STORE_CONNECT_API_KEY_CONTENT_B64` - the base64 encoded contents of .p8 file for App Store Connect API key file. 
12. `GOOGLE_SERVICES_BASE64` - Follow [Firebase setup](https://firebase.google.com/docs/iOS/setup) to add a new iOS app to your Firebase project. This will give you a `GoogleService-Info.plist` file to download. Download this file onto your computer then run `cat GoogleService-Info.plist | base64`. The output is the value for this secret. 
13. `MATCH_GOOGLE_CLOUD_KEYS_B64` - base64 encoded `gc_keys.json` file which Fastlane match uses to read/write provisioning profiles and certificates to Google Cloud bucket. `cat gc_keys.json | base64` gives you the value of this secret. [The development setup doc](DEVELOPMENT.md) explains `gc_keys.json` file more and where to get it. 