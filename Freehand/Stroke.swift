//
//  Stroke.swift
//  Freehand
//
//  Created by Carrl on 16/3/27.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class Stroke:CAShapeLayer{
    let strokePath = CGPathCreateMutable()
    
    init(strokeWidth:CGFloat, strokeColor:NSColor) {
        super.init()
        self.fillColor = NSColor.clearColor().CGColor
        self.strokeColor = strokeColor.CGColor
        self.lineWidth = strokeWidth
        
        //round style
        self.lineJoin = kCALineJoinRound
        self.lineCap = kCALineCapRound
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAt(location:CGPoint, stickedLayer:CALayer){
        CGPathMoveToPoint(self.strokePath, nil, location.x, location.y)
        stickedLayer.addSublayer(self)
        self.sync()
    }
    func moveTo(location:CGPoint){
        CGPathAddLineToPoint(self.strokePath, nil, location.x, location.y)
        self.sync()
    }
    func sync(){
        self.path = self.strokePath
    }
    
}

