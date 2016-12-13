# FirebaseDatabaseUI for iOS — UI Bindings for FirebaseDatabase

FirebaseDatabaseUI is an open-source library for iOS that allows you to quickly connect common UI elements to the [Firebase](https://firebase.google.com?utm_source=FirebaseUI-iOS) database for data storage, allowing views to be updated in realtime as they change, and providing simple interfaces for common tasks like displaying lists or collections of items.

## Installing FirebaseDatabaseUI for iOS

FirebaseDatabaseUI supports iOS 8.0+. To install, [download](https://github.com/ConnorDCrawford/FirebaseDatabaseUI/archive/master.zip) or clone this repository, and then drag and drop the files contained in /FirebaseDatabaseUI into your Xcode project, selecting "Copy items if needed." You will also need to install FirebaseDatabase and SwiftLCS. We recommend using [CocoaPods](https://cocoapods.org/pods/FirebaseUI) to do this. You can do this by adding the following to your `Podfile`:

```ruby
# Only pull in FirebaseUI Database features
pod 'Firebase/Database', '~> 1.0'

# Install SwiftLCS
pod 'SwiftLCS', '>= 1.1.0'
```

Make sure you also have:

```ruby
platform :ios, '8.0'
use_frameworks!
```

## Mandatory Sample Project Configuration

You can download a sample application that uses FirebaseDatabaseUI [here](https://github.com/ConnorDCrawford/FireLister). You have to configure the Xcode project in order to run the sample.

1. You project should contain `GoogleService-Info.plist` downloaded from [Firebase console](https://console.firebase.google.com).<br>
Copy `GoogleService-Info.plist` into sample project folder (`samples/obj-c/GoogleService-Info.plist` or `samples/swift/GoogleService-Info.plist`).<br>
Find more instructions and download a plist file from the [Firebase console](https://console.firebase.google.com).

2. Don't forget to configure your Firebase App Database using [Firebase console](https://console.firebase.google.com).<br>
Database should contain appropriate read/write permissions.

3. Run 'pod install' in the directory of the sample project to install necessary dependencies.
