//
//  Stroke.swift
//  Freehand
//
//  Created by Carrl on 16/3/27.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class Stroke:CAShapeLayer{
  let strokePath = CGMutablePath()

  init(strokeWidth:CGFloat, strokeColor:NSColor) {
    super.init()
    fillColor = NSColor.clear.cgColor
    self.strokeColor = strokeColor.cgColor
    self.lineWidth = strokeWidth

    //round style
    self.lineJoin = kCALineJoinRound
    self.lineCap = kCALineCapRound
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func beginAt(_ location:CGPoint, stickedLayer:CALayer){
    strokePath.move(to: location)
    stickedLayer.addSublayer(self)
    self.sync()
  }
  func moveTo(_ location:CGPoint){
    strokePath.addLine(to: location)
    self.sync()
  }
  func sync(){
    self.path = self.strokePath
  }

}

