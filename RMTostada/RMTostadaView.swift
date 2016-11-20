//
//  RMTostadaView.swift
//  RMTostada
//
//  Created by Rogelio Martinez Kobashi on 11/13/16.
//  Copyright © 2016 Rogelio Martinez Kobashi. All rights reserved.
//

import UIKit

class RMTostadaView: UIView
{
    var fadeDuration: TimeInterval!
    var shiftDuration: TimeInterval!
    var verticalPadding: CGFloat!
    
    init(frame: CGRect, fadeDuration: TimeInterval, shiftDuration: TimeInterval, verticalPadding: CGFloat)
    {
        super.init(frame: frame)
        self.fadeDuration = fadeDuration
        self.shiftDuration = shiftDuration
        self.verticalPadding = verticalPadding
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func identifier() -> String
    {
        return String(UInt(bitPattern: ObjectIdentifier(self)))
    }
}

