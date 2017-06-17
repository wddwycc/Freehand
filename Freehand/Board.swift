//
//  Board.swift
//  Freehand
//
//  Created by Carrl on 16/3/27.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class Board: NSView {
    
    var currentStroke:Stroke?
    
    var currentStrokeWidth:CGFloat = 1
    var currentStrokeColor:NSColor = NSColor.black
    
    var strokeStack = [Stroke]()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    init(){
        super.init(frame: NSRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.layer = CALayer()
        self.layer?.backgroundColor = NSColor.white.cgColor
        //gesture
        let drawGesture = NSPanGestureRecognizer(target: self, action: #selector(Board.handlePan(_:)))
        self.addGestureRecognizer(drawGesture)
        self.layer!.masksToBounds = true
    }
    
    
    func handlePan(_ gesture:NSPanGestureRecognizer){
        switch gesture.state{
        case .began:
            let stroke = Stroke(strokeWidth: self.currentStrokeWidth, strokeColor: self.currentStrokeColor)
            self.currentStroke = stroke
            
            stroke.beginAt(gesture.location(in: self), stickedLayer: self.layer!)
        case .changed:
            self.currentStroke?.moveTo(gesture.location(in: self))
        case .ended, .cancelled:
            self.strokeStack.append(self.currentStroke!)
            self.undoManager!.registerUndo(withTarget: self, selector: #selector(Board.executeUndo), object: nil)
            self.currentStroke = nil
        default:
            break
        }
    }
    
    func executeUndo(){
        self.strokeStack.last?.removeFromSuperlayer()
        self.strokeStack.removeLast()
    }
    
    
    internal func produceImage()->NSImage{
        let size = self.bounds.size
        let im = NSImage.init(size: size)
        
        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0)
        
        im.addRepresentation(rep!)
        im.lockFocus()
        
        let rect = NSMakeRect(0, 0, size.width, size.height)
        let ctx = NSGraphicsContext.current()?.cgContext
        ctx?.clear(rect)
        ctx?.setFillColor(NSColor.clear.cgColor)
        self.layer!.render(in: ctx!)
        ctx?.fill(rect)
        
        im.unlockFocus()
        
        return im
    }
    
    internal func clearboard(){
        if(self.layer!.sublayers == nil){return}
        for member in self.layer!.sublayers!{
            member.removeFromSuperlayer()
        }
        self.strokeStack.removeAll()
    }
    
    
    
//    override func drawRect(dirtyRect: NSRect) {
//        super.drawRect(dirtyRect)
//
//        // Drawing code here.
//    }
    
}
