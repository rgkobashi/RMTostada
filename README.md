# RMTostada

The `RMTostada` class provides static methods to display tostadas views with differentstyles. `RMTostada` is capable to display more than one tostada view at the same time, every tostada view will be appended to a queue. When a tostada view will be dismissed, all the subsequent tostadas views on the queue (on the screen), will be shifted.

Basically there are three different tostadas views:

* **Self dismissed:** These tostadas views will be dismissed automatically after a time interval.
* **Manually dismissed:** These tostadas needs to be dismissed manually calling `dismissWithId` and sending the id of the tostada to dismiss.
* **Manually dismissed with activity indicator:** Same as **Manually dismissed** just that these will include an `UIActivityIndicatorView` at the end of the text.

All the tostadas will be displayed on the rootViewController view, if there is one `(UIApplication.sharedApplication().windows.first?.rootViewController)` so it can be used on an `UITabBarController` based application and all the tostadas views will be visible from every tab.

The styles were based on [Toast-Swift](https://github.com/scalessec/Toast-Swift) pod by Charles Scalesse.

## Screenshots

![Screenshot](/screenshots/main.jpg)

## Install

Using cocoapod. Minimum deployment target is iOS 8.0.

```
pod 'RMTostada'
```

## Example

```swift
// Basic usage
RMTostada.showSelfDismissingWithText("Self dismissing with default duration")
RMTostada.showSelfDismissingWithText("Self dismissing with specified duration", duration: 5)

// Custom style
var style = RMTostadaStyle()
style.textColor = UIColor.yellow
style.backgroundColor = UIColor.red
style.contentHorizontalPadding = 3
style.contentVerticalPadding = 3
style.cornerRadius = 3
style.font = UIFont(name: "BradleyHandITCTT-Bold", size: 14)!
style.displayShadow = true
style.shadowColor = UIColor.orange
RMTostada.showSelfDismissingWithText("Self dismissing with custom style", style: style)

// With completition handler
RMTostada.showSelfDismissingWithText("Self dismissing with comp handler", completion: {
    RMTostada.showSelfDismissingWithText("From completition handler")
})

// With activity indicator
let defaultStyleId = RMTostada.showActivityWithText("Show activity with default style")
RMTostada.dismissWithId(defaultStyleId)
```

## License

```
MIT License

Copyright (c) 2016 Rogelio Martinez Kobashi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```