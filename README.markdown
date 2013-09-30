# Parse Developer Day app #

This is the entire source code of the official [Parse Developer Day](http://www.parsedeveloperday.com) apps, available on the [App Store](https://itunes.apple.com/us/app/parse-developer-day/id691488056) as well as on [Google Play](https://play.google.com/store/apps/details?id=com.parse.parsedevday). 

Read more about these apps on our blog:

* [Introducing the Parse Developer Day Apps for Android and iOS](http://blog.parse.com/2013/08/29/introducing-the-parse-developer-day-apps-for-android-and-ios/)
* [Technically Non-Technical: The Parse Data Browser](http://blog.parse.com/2013/09/26/technically-non-technical-the-parse-data-browser/)
* [Parse Developer Day Apps, Now Open-Sourced](http://blog.parse.com/2013/10/01/parse-developer-day-apps-now-open-sourced)

## iOS Quick Setup ##

The iOS Parse Developer Day app is ready to be used without further modifications as it is already configured with the same app keys as the App Store version of the Parse Developer Day app. To run a local build of the PDD app:

1. Clone this repo locally.
2. Open `ios/Parse Dev Day.xcodeproj` in Xcode 5.
3. Build and Run.

The iOS PDD app can be built with both the iOS 6 and iOS 7 SDKs. It has a minimum target OS version of 6.1, and will degrade gracefully when run on iOS 6 devices.

## Android Quick Setup ##

The Android Parse Developer Day is already configured to connect to the production PDD Parse app. It requires Android's Support Library, though, you'll need to perform some additional steps before you can build and run the app for the first time.

1. Clone this repo locally.
2. Open `android/` in your IDE of choice, such as Eclipse.
3. Go to http://developer.android.com/tools/support-library/setup.html and follow the instructions to set up your project to use the Android Support Library.
4. Build and Run.

## Using Your Own Conference Data ##

As mentioned earlier, both versions of the PDD app are already configured to use the same Parse app as the App Store and Google Play versions of the PDD app. This is great if you just want to build and run the app and learn how it is all set up with Parse. However, if you're interested in reusing the codebase for your own conference app, you will need to create a new Parse app. For simplicity, we've included a JSON export of the Parse Developer Day Parse app which you can use for an initial import of data into your own app.

1. Go to your [Dashboard](https://parse.com/apps) and create a new Parse app.
2. Write down your new application id and client key. You will need these later. Remember that you can always get your keys from your app's Settings page.
3. Locate the `data` folder in your local clone of the PDD repo. Here you will find `Talk.json`, `Speaker.json`, `Slot.json`, and `Room.json`. These can be imported into your brand new Parse app.
4. Go to your app's Data Browser, and click on the "Import" button. Choose `Talk.json` and give your new class the name "Talk". Repeat this for each of the json files in the `data` folder, giving them the appropriate class name.
5. Set up your app keys in your project (see "Custom App Setup" below).
6. Build and Run.

Confirm that everything is working correctly. You may now modify the list of Talks, Speakers, and Rooms to suit your conference.

### iOS Custom App Setup ###

Open the `PDDAppDelegate.m` file and modify the following two lines to use your actual Parse application id and client key, as noted in step 2 above:

```
[Parse setApplicationId:@"YOUR_APPLICATION_ID"
              clientKey:@"YOUR_CLIENT_KEY"];
```

### Android Custom App Setup ###

Open the `ParseDevDayApp.java` file and modify the following two lines to use your actual Parse application id and client key, as noted in step 2 above:

```
Parse.initialize(this, "YOUR_APPLICATION_ID",
  "YOUR_CLIENT_KEY");
```
