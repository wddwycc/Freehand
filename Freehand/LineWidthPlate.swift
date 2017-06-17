//
//  LineWidthPlate.swift
//  Freehand
//
//  Created by Carrl on 16/3/27.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

protocol LineWidthPlateDelegate:class{
  func didChange(_ width:CGFloat)
}

class LineWidthPlate: NSView {
  let minWidth:CGFloat = 1
  let maxWidth:CGFloat = 10

  let bgLayer = CAShapeLayer()
  let bubble = CALayer()
  let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 205, height: 20))


  weak var delegate:LineWidthPlateDelegate?

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
    self.layer?.backgroundColor = NSColor(calibratedRed: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1).cgColor
    self.layer?.cornerRadius = 8
    self.layer?.shadowOpacity = 0.1

    //draw the bg
    let bgPath = CGMutablePath()
    bgPath.move(to: CGPoint(x: 24, y: 28))
    bgPath.addLine(to: CGPoint(x: 175, y: 17))
    bgPath.addArc(
      center: CGPoint(x: 175, y: 35), radius: 18,
      startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi / 2),
      clockwise: false
    )
    bgPath.addLine(to: CGPoint(x: 24, y: 42))
    bgPath.addArc(
      center: CGPoint(x: 24, y: 35), radius: 7,
      startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi / 2),
      clockwise: true)
    self.bgLayer.path = bgPath
    self.bgLayer.fillColor = NSColor(white: 123.0/255.0, alpha: 1).cgColor
    self.layer!.addSublayer(bgLayer)

    //draw the bubble
    self.bubble.backgroundColor = NSColor(calibratedRed: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1).cgColor
    self.layer!.addSublayer(self.bubble)
    self.updateBubbleState(0)

    //text
    self.textView.string = "1px"
    self.textView.textColor = NSColor(calibratedHue: 64.0/255.0, saturation: 81.0/255.0, brightness: 78.0/255.0, alpha: 1)
    self.textView.alignment = NSTextAlignment.center
    self.textView.font = NSFont.systemFont(ofSize: 12)
    self.textView.backgroundColor = NSColor.clear
    self.textView.isSelectable = false
    self.textView.isEditable = false
    self.addSubview(self.textView)


    //pan gesture
    let panGesture = NSPanGestureRecognizer(target: self, action: #selector(LineWidthPlate.handlePan(_:)))
    self.addGestureRecognizer(panGesture)

  }

  func handlePan(_ gesture:NSPanGestureRecognizer){
    switch gesture.state{
    case .changed, .began:
      let percentage:CGFloat
      if(gesture.location(in: self).x <= 24){
        percentage = 0
      }else if(gesture.location(in: self).x >= 175){
        percentage = 1
      }else{
        percentage = (gesture.location(in: self).x - 24) / (175 - 24)
      }
      self.updateBubbleState(percentage)
      let targetWidth = self.minWidth + (self.maxWidth - self.minWidth) * percentage
      self.textView.string = "\(Int(targetWidth))px"
      self.delegate?.didChange(targetWidth)
    default:
      break
    }
  }

  override func mouseDown(with theEvent: NSEvent) {
    super.mouseDown(with: theEvent)

    let event_location = theEvent.locationInWindow
    let local_point = self.convert(event_location, from: nil)

    let percentage:CGFloat
    if(local_point.x <= 24){
      percentage = 0
    }else if(local_point.x >= 175){
      percentage = 1
    }else{
      percentage = (local_point.x - 24) / (175 - 24)
    }
    self.updateBubbleState(percentage)
    let targetWidth = self.minWidth + (self.maxWidth - self.minWidth) * percentage
    self.textView.string = "\(Int(targetWidth))px"
    self.delegate?.didChange(targetWidth)
  }

  func updateBubbleState(_ percentage:CGFloat){
    //min: 6, 6
    //max: 20,20
    //center: 24, 35 => 175, 35


    let centerX = 24 + (175 - 24) * percentage
    let radius = 3 + (10 - 3) * percentage
    self.bubble.frame = NSRect(x: centerX - radius, y: 35 - radius, width: radius * 2, height: radius * 2)
    self.bubble.cornerRadius = radius
  }
  
  
}
