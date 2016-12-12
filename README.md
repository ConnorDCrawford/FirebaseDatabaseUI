# FirebaseUI for iOS — UI Bindings for Firebase [![Build Status](https://travis-ci.org/firebase/FirebaseUI-iOS.svg?branch=master)](https://travis-ci.org/firebase/FirebaseUI-iOS)

FirebaseUI is an open-source library for iOS that allows you to quickly connect common UI elements to the [Firebase](https://firebase.google.com?utm_source=FirebaseUI-iOS) database for data storage, allowing views to be updated in realtime as they change, and providing simple interfaces for common tasks like displaying lists or collections of items.

## Installing FirebaseUI for iOS

FirebaseUI supports iOS 8.0+. To install, [download](https://github.com/ConnorDCrawford/FirebaseDatabaseUI/archive/master.zip) or clone this repository, and then drag and drop the files contained in /FirebaseDatabaseUI into your Xcode project, selecting "Copy items if needed." You will also need to install FirebaseDatabase and SwiftLCS. We recommend using [CocoaPods](https://cocoapods.org/pods/FirebaseUI) to do this. You can do this by adding the following to your `Podfile`:

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

## Contributing to FirebaseDatabaseUI

### Contributor License Agreements

We'd love to accept your sample apps and patches! Before we can take them, we
have to jump a couple of legal hurdles.

Please fill out either the individual or corporate Contributor License Agreement
(CLA).

  * If you are an individual writing original source code and you're sure you
    own the intellectual property, then you'll need to sign an [individual CLA]
    (https://developers.google.com/open-source/cla/individual).
  * If you work for a company that wants to allow you to contribute your work,
    then you'll need to sign a [corporate CLA]
    (https://developers.google.com/open-source/cla/corporate).

Follow either of the two links above to access the appropriate CLA and
instructions for how to sign and return it. Once we receive it, we'll be able to
accept your pull requests.

### Contribution Process

1. Submit an issue describing your proposed change to the repo in question.
2. The repo owner will respond to your issue promptly.
3. If your proposed change is accepted, and you haven't already done so, sign a
   Contributor License Agreement (see details above).
4. Fork the desired repo, develop and test your code changes.
5. Ensure that your code adheres to the existing style of the library to which
   you are contributing.
6. Ensure that your code has an appropriate set of unit tests which all pass.
7. Submit a pull request
