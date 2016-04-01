//
//  LineWidthPlate.swift
//  Freehand
//
//  Created by Carrl on 16/3/27.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

protocol LineWidthPlateDelegate{
    func didChange(width:CGFloat)
}

class LineWidthPlate: NSView {
    let minWidth:CGFloat = 1
    let maxWidth:CGFloat = 10
    
    let bgLayer = CAShapeLayer()
    let bubble = CALayer()
    let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 205, height: 20))
    
    
    var delegate:LineWidthPlateDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        //basic 
        self.layer = CALayer()
        self.layer?.backgroundColor = NSColor(calibratedRed: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1).CGColor
        self.layer?.cornerRadius = 8
        self.layer?.shadowOpacity = 0.1
        
        //draw the bg
        let bgPath = CGPathCreateMutable()
        CGPathMoveToPoint(bgPath, nil, 24, 28)
        CGPathAddLineToPoint(bgPath, nil, 175, 17)
        CGPathAddArc(bgPath, nil, 175, 35, 18, CGFloat(-M_PI_2), CGFloat(M_PI_2), false)
        CGPathAddLineToPoint(bgPath, nil, 24, 42)
        CGPathAddArc(bgPath, nil, 24, 35, 7, CGFloat(-M_PI_2), CGFloat(M_PI_2), true)
        self.bgLayer.path = bgPath
        self.bgLayer.fillColor = NSColor(white: 123.0/255.0, alpha: 1).CGColor
        self.layer!.addSublayer(bgLayer)
        
        //draw the bubble
        self.bubble.backgroundColor = NSColor(calibratedRed: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1).CGColor
        self.layer!.addSublayer(self.bubble)
        self.updateBubbleState(0)
        
        //text
        self.textView.string = "1px"
        self.textView.textColor = NSColor(calibratedHue: 64.0/255.0, saturation: 81.0/255.0, brightness: 78.0/255.0, alpha: 1)
        self.textView.alignment = NSTextAlignment.Center
        self.textView.font = NSFont.systemFontOfSize(12)
        self.textView.backgroundColor = NSColor.clearColor()
        self.textView.editable = false
        self.addSubview(self.textView)
        
        
        //pan gesture
        let panGesture = NSPanGestureRecognizer(target: self, action: #selector(LineWidthPlate.handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        
        
        
    }
    
    func handlePan(gesture:NSPanGestureRecognizer){
        switch gesture.state{
        case .Changed, .Began:
            let percentage:CGFloat
            if(gesture.locationInView(self).x <= 24){
                percentage = 0
            }else if(gesture.locationInView(self).x >= 175){
                percentage = 1
            }else{
                percentage = (gesture.locationInView(self).x - 24) / (175 - 24)
            }
            self.updateBubbleState(percentage)
            let targetWidth = self.minWidth + (self.maxWidth - self.minWidth) * percentage
            self.textView.string = "\(Int(targetWidth))px"
            self.delegate?.didChange(targetWidth)
        default:
            break
        }
        
    }
    
    
    
    func updateBubbleState(percentage:CGFloat){
        //min: 6, 6
        //max: 20,20
        //center: 24, 35 => 175, 35
        
        
        let centerX = 24 + (175 - 24) * percentage
        
        let radius = 3 + (10 - 3) * percentage
        
        self.bubble.frame = NSRect(x: centerX - radius, y: 35 - radius, width: radius * 2, height: radius * 2)
        
        self.bubble.cornerRadius = radius
    }
    
    
}
