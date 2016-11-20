//
//  RMTostada.swift
//  RMTostada
//
//  Created by Rogelio Martinez Kobashi on 11/13/16.
//  Copyright © 2016 Rogelio Martinez Kobashi. All rights reserved.
//

import Foundation
import UIKit

/**
 Completion handler used on all the `showSelfDismissingWithText` methods.
 */
public typealias CompletionHandler = () -> ()

private class RMClosureWrapper<T>
{
    fileprivate let value: T
    
    fileprivate init(value: T)
    {
        self.value = value
    }
}

/**
 Define the look and feel for the tostada view.
 */
public struct RMTostadaStyle
{
    /**
     Creates an instance of `RMTostadaStyle` with the default values.
     
     - returns: An instance of RMTostadaStyle.
     */
    public init()
    {
        
    }
    
    /**
     The background color. Default is `UIColor.blackColor()` at 80% opacity.
     */
    public var backgroundColor = UIColor.black.withAlphaComponent(0.8)
    
    /**
     The text color. Default is `UIColor.whiteColor()`.
     */
    public var textColor = UIColor.white
    
    /**
     A percentage value from 0.0 to 1.0, representing the maximum width of the tostada
     view relative to it's superview. Default is 0.8 (80% of the superview's width).
     */
    public var maxWidthPercentage: CGFloat = 0.8 {
        didSet {
            maxWidthPercentage = max(min(maxWidthPercentage, 1.0), 0.0)
        }
    }
    
    /**
     The spacing from the vertical edge of the tostada superview to the tostada view.
     Default is 10.0.
     */
    public var tostadaVerticalPadding: CGFloat = 10.0
    
    /**
     The spacing from the horizontal edge of the tostada view to the content.
     If the tostada has `UIActivityIndicatorView` this value will be used as padding
     between the text and the `UIActivityIndicatorView`.
     Default is 10.0.
     */
    public var contentHorizontalPadding: CGFloat = 10.0
    
    /**
     The spacing from the vertical edge of the tostada view to the content.
     Default is 10.0.
     */
    public var contentVerticalPadding: CGFloat = 10.0
    
    /**
     The corner radius. Default is 10.0.
     */
    public var cornerRadius: CGFloat = 10.0;
    
    /**
     The text font. Default is `UIFont.systemFontOfSize(16.0)`.
     */
    public var font = UIFont.systemFont(ofSize: 16.0)
    
    /**
     Enable or disable a shadow on the tostada view. Default is `false`.
     */
    public var displayShadow = false;
    
    /**
     The shadow color. Default is `UIColor.blackColor()`.
     */
    public var shadowColor = UIColor.black
    
    /**
     A value from 0.0 to 1.0, representing the opacity of the shadow.
     Default is 0.8 (80% opacity).
     */
    public var shadowOpacity: Float = 0.8 {
        didSet {
            shadowOpacity = max(min(shadowOpacity, 1.0), 0.0)
        }
    }
    
    /**
     The shadow radius. Default is 6.0.
     */
    public var shadowRadius: CGFloat = 6.0
    
    /**
     The shadow offset. The default is 4 x 4.
     */
    public var shadowOffset = CGSize(width: 4.0, height: 4.0)
    
    /**
     The fade in/out animation duration. Default is 0.2.
     */
    public var fadeDuration: TimeInterval = 0.2
    
    /**
     The shift animation duration. This animation will be executed when
     a tostada view has been dismissed and there are more on the queue (on the screen),
     the subsequent tostadas will be shifted. Default is 0.2.
     */
    public var shiftDuration: TimeInterval = 0.2
    
    /**
     The style of the `UIActivityIndicatorView` that will be used on
     `showActivityWithText` method. Default is `UIActivityIndicatorViewStyle.White`.
     */
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .white
    
}

/**
 The `RMTostada` class provides static methods to display tostadas views with different
 styles. `RMTostada` is capable to display more than one tostada view at the same time,
 every tostada view will be appended to a queue. When a tostada view will be dismissed,
 all the subsequent tostadas views on the queue (on the screen), will be shifted.
 Basically there are three different tostadas views:
 
 - Self dismissed: These tostadas views will be dismissed automatically after a time interval.
 - Manually dismissed: These tostadas needs to be dismissed manually calling `dismissWithId`
 and sending the id of the tostada to dismiss.
 - Manually dismissed with activity indicator: Same as `Manually dismissed` just
 that these will include an `UIActivityIndicatorView` at the end of the text.
 
 All the tostadas will be displayed on the rootViewController view, if there is one
 (`UIApplication.sharedApplication().windows.first?.rootViewController`).
 
 This framework is based on Toast-Swift pod by Charles Scalesse (https://github.com/scalessec/Toast-Swift).
 */
open class RMTostada
{
    /**
     The default duration that the tostada view will remain on the screen. This applies only
     on the self dismissed tostada. Default is 3.0.
     */
    open static var duration: TimeInterval = 3.0
    
    /**
     The default style that all the tostadas views will have if no style is specified.
     */
    open static var style = RMTostadaStyle()
    
    fileprivate static let sharedInstance = RMTostada()
    
    fileprivate var queue = [RMTostadaView]()
    fileprivate let screenSize = UIScreen.main.bounds
    
    fileprivate init()
    {
        
    }
    
    // MARK: - Exposed methods
    
    /**
     Shows a tostada view with the given text and the default style that will be dismissed automatically after the default duration.
     If the param `completion` is specified, it will be executed after the tostada view is dismissed.
     
     - parameter text: The text that the tostada view will have
     - parameter completion: Code that will be executed after the tostada view is dismissed
     */
    open class func showSelfDismissingWithText(_ text: String, completion: CompletionHandler? = nil)
    {
        showSelfDismissingWithText(text, duration: duration, style: style, completion: completion)
    }
    
    /**
     Shows a tostada view with the given text and the default style that will be dismissed automatically after the given duration.
     If the param `completion` is specified, it will be executed after the tostada view is dismissed.
     
     - parameter text: The text that the tostada view will have
     - parameter duration: The duration that the tostada view will remain on the screen.
     - parameter completion: Code that will be executed after the tostada view is dismissed
     */
    open class func showSelfDismissingWithText(_ text: String, duration: TimeInterval, completion: CompletionHandler? = nil)
    {
        showSelfDismissingWithText(text, duration: duration, style: style, completion: completion)
    }
    
    /**
     Shows a tostada view with the given text and the given style that will be dismissed automatically after the default duration.
     If the param `completion` is specified, it will be executed after the tostada view is dismissed.
     
     - parameter text: The text that the tostada view will have
     - parameter style: The style that the tostada view will have
     - parameter completion: Code that will be executed after the tostada view is dismissed
     */
    open class func showSelfDismissingWithText(_ text: String, style: RMTostadaStyle, completion: CompletionHandler? = nil)
    {
        showSelfDismissingWithText(text, duration: duration, style: style, completion: completion)
    }
    
    /**
     Shows a tostada view with the given text and the given style that will be dismissed automatically after the given duration.
     If the param `completion` is specified, it will be executed after the tostada view is dismissed.
     
     - parameter text: The text that the tostada view will have
     - parameter duration: The duration that the tostada view will remain on the screen.
     - parameter style: The style that the tostada view will have
     - parameter completion: Code that will be executed after the tostada view is dismissed
     */
    open class func showSelfDismissingWithText(_ text: String, duration: TimeInterval, style: RMTostadaStyle, completion: CompletionHandler? = nil)
    {
        let tostada = sharedInstance.createTostadaWithText(text, style: style, activityIndicator: false)
        objc_sync_enter(sharedInstance)
        sharedInstance.displayTostada(tostada, selfDismissing: true, duration: duration, completion: completion)
        objc_sync_exit(sharedInstance)
    }
    
    /**
     Shows a tostada view with the given text and the given style (if it is specified, otherwise the default style will be used) and returns its id.
     To dismiss the tostada view showed a call to `dismissWithId` will be needed.
     
     - parameter text: The text that the tostada view will have
     - parameter style: The style that the tostada view will have
     
     - returns: The id of the tostada view showed.
     */
    open class func showWithText(_ text: String, style: RMTostadaStyle = style) -> String
    {
        let tostada = sharedInstance.createTostadaWithText(text, style: style, activityIndicator: false)
        objc_sync_enter(sharedInstance)
        sharedInstance.displayTostada(tostada, selfDismissing: false, duration: nil, completion: nil)
        objc_sync_exit(sharedInstance)
        return tostada.identifier()
    }
    
    /**
     Shows a tostada view with the given text and the given style (if it is specified, otherwise the default style will be used) with an
     `UIActivityIndicatorView` at the end of the text and returns its id. To dismiss the tostada view showed a call to `dismissWithId` will be needed.
     
     - parameter text: The text that the tostada view will have
     - parameter style: The style that the tostada view will have
     
     - returns: The id of the tostada view showed.
     */
    open class func showActivityWithText(_ text: String, style: RMTostadaStyle = style) -> String
    {
        let tostada = sharedInstance.createTostadaWithText(text, style: style, activityIndicator: true)
        objc_sync_enter(sharedInstance)
        sharedInstance.displayTostada(tostada, selfDismissing: false, duration: nil, completion: nil)
        objc_sync_exit(sharedInstance)
        return tostada.identifier()
    }
    
    /**
     Dismiss the tostada view with the id given.
     
     - parameter id: The id of the tostada view that will be dismissed
     */
    open class func dismissWithId(_ id: String)
    {
        let filtered = sharedInstance.queue.filter { $0.identifier() == id }
        if let first = filtered.first
        {
            objc_sync_enter(sharedInstance)
            sharedInstance.hideTostada(first, completion: nil)
            objc_sync_exit(sharedInstance)
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func topView() -> UIView?
    {
        if let view = UIApplication.shared.windows.first?.rootViewController?.view
        {
            return view
        }
        return nil
    }
    
    // MARK: - Create tostada
    
    fileprivate func createTostadaWithText(_ text: String, style: RMTostadaStyle, activityIndicator: Bool) -> RMTostadaView
    {
        // Setup wrapper view
        let wrapperView = RMTostadaView(frame: CGRect.zero, fadeDuration: style.fadeDuration, shiftDuration: style.shiftDuration, verticalPadding: style.tostadaVerticalPadding)
        wrapperView.backgroundColor = style.backgroundColor
        wrapperView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        wrapperView.layer.cornerRadius = style.cornerRadius
        if style.displayShadow
        {
            wrapperView.layer.shadowColor = style.shadowColor.cgColor
            wrapperView.layer.shadowOpacity = style.shadowOpacity
            wrapperView.layer.shadowRadius = style.shadowRadius
            wrapperView.layer.shadowOffset = style.shadowOffset
        }
        
        // Setup label
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.numberOfLines = 1
        textLabel.font = style.font
        textLabel.lineBreakMode = .byTruncatingTail;
        textLabel.textColor = style.textColor
        textLabel.backgroundColor = UIColor.clear
        textLabel.sizeToFit()
        textLabel.frame = CGRect(x: style.contentHorizontalPadding, y: style.contentVerticalPadding, width: textLabel.frame.width, height: textLabel.frame.height)
        
        // Setup wrapper view size
        let wrapperHeight = (textLabel.frame.height + (style.contentVerticalPadding * 2))
        var wrapperWidth = (textLabel.frame.width + (style.contentHorizontalPadding * 2))
        
        // Setup activity indicator
        var activityView: UIActivityIndicatorView?
        var activityXPos: CGFloat?
        var activityYPos: CGFloat?
        if activityIndicator
        {
            activityView = UIActivityIndicatorView(activityIndicatorStyle: style.activityIndicatorViewStyle)
            activityXPos = style.contentHorizontalPadding + textLabel.frame.width + style.contentHorizontalPadding
            activityYPos = (wrapperHeight - activityView!.frame.size.height) / 2
            activityView!.frame = CGRect(x: activityXPos!, y: activityYPos!, width: activityView!.frame.size.width, height: activityView!.frame.size.height)
            wrapperView.addSubview(activityView!)
            activityView!.startAnimating()
            wrapperWidth += activityView!.frame.size.width + style.contentHorizontalPadding
        }
        
        // Handler if the wrapper view exceeds the maxWidthPercentage
        let wrapperMaxWidth = screenSize.size.width * style.maxWidthPercentage
        if wrapperWidth > wrapperMaxWidth
        {
            if activityIndicator
            {
                let labelMaxWidth = wrapperMaxWidth - (style.contentHorizontalPadding * 3) - activityView!.frame.size.width
                textLabel.frame = CGRect(x: textLabel.frame.origin.x, y: textLabel.frame.origin.y, width: labelMaxWidth, height: textLabel.frame.size.height)
                activityXPos = style.contentHorizontalPadding + textLabel.frame.width + style.contentHorizontalPadding
                activityYPos = (wrapperHeight - activityView!.frame.size.height) / 2
                activityView!.frame = CGRect(x: activityXPos!, y: activityYPos!, width: activityView!.frame.size.width, height: activityView!.frame.size.height)
            }
            else
            {
                let labelMaxWidth = wrapperMaxWidth - (style.contentHorizontalPadding * 2)
                textLabel.frame = CGRect(x: textLabel.frame.origin.x, y: textLabel.frame.origin.y, width: labelMaxWidth, height: textLabel.frame.size.height)
            }
            wrapperWidth = wrapperMaxWidth
        }
        
        // Place wrapper view
        let wrapperXPos = (screenSize.size.width - wrapperWidth) / 2
        var wrapperYPos: CGFloat = 0.0
        for view in queue
        {
            wrapperYPos += view.verticalPadding + view.frame.size.height
        }
        wrapperYPos += style.tostadaVerticalPadding
        
        wrapperView.frame = CGRect(x: wrapperXPos, y: wrapperYPos, width: wrapperWidth, height: wrapperHeight)
        wrapperView.addSubview(textLabel)
        
        return wrapperView
    }
    
    // MARK: - Tostadas queue
    
    fileprivate func appendTostada(_ tostada: RMTostadaView)
    {
        queue.append(tostada)
    }
    
    fileprivate func removeTostada(_ tostada: RMTostadaView) -> Int?
    {
        objc_sync_enter(self)
        if let index = queue.index(of: tostada)
        {
            queue.remove(at: index)
            objc_sync_exit(queue)
            return index
        }
        objc_sync_exit(self)
        return nil
    }
    
    // MARK: - Display/hide tostada
    
    fileprivate func displayTostada(_ tostada: RMTostadaView, selfDismissing: Bool, duration: TimeInterval?, completion: CompletionHandler?)
    {
        if let topView = self.topView()
        {
            var dict = [String: AnyObject]()
            dict["RMTostadaView"] = tostada
            if let completion = completion
            {
                dict["completion"] = RMClosureWrapper(value: completion)
            }
            tostada.alpha = 0.0
            topView.addSubview(tostada)
            appendTostada(tostada)
            DispatchQueue.main.async(execute: { () -> Void in
                UIView.animate(withDuration: tostada.fadeDuration, delay: 0.0, options: [.curveEaseOut], animations: { () -> Void in
                    tostada.alpha = 1.0
                }) { (finished) -> Void in
                    if let duration = duration, selfDismissing
                    {
                        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(RMTostada.tostadaTimerDidFinish(_:)), userInfo: dict, repeats: false)
                    }
                }
            })
        }
    }
    
    @objc fileprivate func tostadaTimerDidFinish(_ timer: Timer)
    {
        if let dict = timer.userInfo as? [String: AnyObject]
        {
            let tostada = dict["RMTostadaView"] as! RMTostadaView
            if let closureWrapper = dict["completion"] as? RMClosureWrapper<CompletionHandler>
            {
                objc_sync_enter(self)
                hideTostada(tostada, completion: closureWrapper.value)
                objc_sync_exit(self)
            }
            else
            {
                objc_sync_enter(self)
                hideTostada(tostada, completion: nil)
                objc_sync_exit(self)
            }
        }
    }
    
    fileprivate func hideTostada(_ tostada: RMTostadaView, completion: CompletionHandler?)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            UIView.animate(withDuration: tostada.fadeDuration, delay: 0.0, options: [.curveEaseIn], animations: { () -> Void in
                tostada.alpha = 0.0
            }) { [unowned self] (didFinish: Bool) -> Void in
                tostada.removeFromSuperview()
                completion?()
                if let index = self.removeTostada(tostada)
                {
                    objc_sync_enter(self)
                    self.shiftTostadasFromIndex(index)
                    objc_sync_exit(self)
                }
            }
        })
    }
    
    // MARK: - Move tostadas which are on the queue
    
    fileprivate func shiftTostadasFromIndex(_ index: Int)
    {
        for index in index ..< queue.count
        {
            let tostada = queue[index]
            shiftTostada(tostada)
        }
    }
    
    fileprivate func shiftTostada(_ tostada: RMTostadaView)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            UIView.animate(withDuration: tostada.shiftDuration, animations: {
                let yPos = tostada.frame.origin.y - tostada.verticalPadding - tostada.frame.size.height
                let frame = CGRect(x: tostada.frame.origin.x, y: yPos, width: tostada.frame.size.width, height: tostada.frame.size.height)
                tostada.frame = frame
            }) 
        })
    }
}
