iOS 7 Compatibility
===================

A compatibility class to use some of the more important iOS 7 methods on previous versions of iOS.

## Supported Features
* UIView tint color
* barTintColor in UINavigationBar, UITabBar, UIToolbar and UISearchBar
* UIImage rendering modes

## Usage
All methods have been implemented with a "shn" prefix for compatibility with both the iOS 7 APIs and prior APIs (for instance, calling `-setShnBarTintColor:` on iOS 7 will simply redirect to `-setBarTintColor`, but on iOS 6 it'll redirect to `-setTintColor`).  APIs are the same as their iOS 7 UIKit counterparts, so check the UIKit docs on how to use them.  Check the SHNCompat.h header for a list of supported methods.

You'll need to "start" SHNCompat by calling `[SHNCompat start]` in your app delegate.

## License
GPLv2, check the LICENSE file for full details.