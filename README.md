## Noober

<p align="center">
<img alt="Version" src="https://img.shields.io/badge/version-1.20.0-green.svg?style=flat-square" />
<a href="https://travis-ci.org/kasketis/netfox"><img alt="CI Status" src="http://img.shields.io/travis/kasketis/netfox.svg?style=flat-square" /></a>
<a href="https://cocoapods.org/pods/Noober"><img alt="Cocoapods Compatible" src="https://img.shields.io/cocoapods/v/netfox.svg?style=flat-square" /></a>
<a href="https://opensource.org/licenses/MIT"><img alt="License" src="https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square" /></a>
</p>


Noober is a network debugger library that grabs all the network request (also supports 3rd party libraries such as AFNetworking, Alamofire or else) and provides a quick look on all executed network requests performed by the iOS app. It also has the functionality to view or edit UserDefaults, mock api response, edit api response beofre sending it back to the client.

Very useful and handy for network related issues and bugs

Supports Swift 5 and above

### Overview
| ![](https://github.com/ABHI165/Noober/blob/main/assets/apiCalls.gif)  | ![](https://github.com/ABHI165/Noober/blob/main/assets/intercept.gif) |
|---|---|

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To integrate Noober into your Xcode project using CocoaPods, specify it in your `Podfile`:

<pre>
use_frameworks!
pod 'Noober'
</pre>

To bundle only on some build configurations specify them after pod.

<pre>
use_frameworks!
pod 'Noober', :configurations => ['Debug', 'Test']
</pre>

### Manually

If you prefer not to use dependency managers, you can integrate Noober into your project manually.

You can do it by copying the "netfox" folder in your project (make sure that "Create groups" option is selected)

## Start

#### Swift
```swift
// AppDelegate
import Noober
Noob.shared.startLogging() // in didFinishLaunchingWithOptions:
```
That's it!

Note: Please wrap the above line with
```c
#if DEBUG
. . .
#endif
```
to prevent library’s execution on your production app.

You can add the DEBUG symbol with the -DDEBUG entry. Set it in the "Swift Compiler - Custom Flags" section -> "Other Swift Flags" line in project’s "Build Settings"

## Usage 

Just shake your device and check what's going right or wrong! 
Shake again and go back to your app!
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/shake.png)

## Stop

Call
```swift
Noob.shared.stopLogging()
```
to stop Noober and clear all saved data. 
If you stop Noober its view will not be displayed until you call start method again. 

## Prevent logging for specific URLs

Use the following method to prevent requests for specified URL from being logged. You can ignore as many URLs as you want
```swift
Noob.shared.ignoredURL = ["url"]
```
 You can also use the url of the host (for example "https://www.github.com") to ignore all paths of it 
 
 ## Itercept response for specific URLs

Use the following method to Itercept response for specified URL . You can intercept as many URLs as you want
```swift
Noob.shared.interceptForURLS = ["url"]
```
 ## Mock API response for specific URLs

Use the following method to mock response for specified URL . You can mock as many URLs as you want
```swift
 Noob.shared.mockResponseForURLs = ["url", "response"]
```


## Features

- Intercept: Change api response before the iOS app receives it
- Mock the api response 
- Search: You can easily search among requests via
	- Request url: github.com, .gr, or whatever you want
	- Request method: GET, POST, etc

- Sharing: Log tap to copy response, request or anything you want!
- Enable/disable logging within the app
- More to come.. ;)


## Licence

All source code is licensed under [MIT License](https://github.com/ABHI165/Noober/blob/main/LICENSE).

