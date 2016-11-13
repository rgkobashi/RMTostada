## RMTostada

The **RMTostada** class provides static methods to display tostadas views with differentstyles. **RMTostada** is capable to display more than one tostada view at the same time, every tostada view will be appended to a queue. When a tostada view will be dismissed, all the subsequent tostadas views on the queue (on the screen), will be shifted.

Basically there are three different tostadas views:

* *Self dismissed:* These tostadas views will be dismissed automatically after a time interval.
* *Manually dismissed:* These tostadas needs to be dismissed manually calling *dismissWithId* and sending the id of the tostada to dismiss.
* *Manually dismissed with activity indicator:* Same as *Manually dismissed* just that these will include an *UIActivityIndicatorView* at the end of the text.

All the tostadas will be displayed on the rootViewController view, if there is one *(UIApplication.sharedApplication().windows.first?.rootViewController)*.

This framework is based on [Toast-Swift](https://github.com/scalessec/Toast-Swift) pod by Charles Scalesse.

### Install

Using cocoapod. Minimum deployment target is iOS 8.0.

```
pod 'RMTostada', '1.0.0'
```
