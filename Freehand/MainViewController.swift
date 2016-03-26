//
//  MainViewController.swift
//  Freehand
//
//  Created by Carrl on 16/3/26.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var sampleView: NSView!
    let sampleLayer = CALayer()
    
    let realImage = NSImage()
    
    
    let path = CGPathCreateMutable()
    
    let pathLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.sampleView.layer = sampleLayer
        self.sampleView.layer!.backgroundColor = NSColor.whiteColor().CGColor
        
        
        self.sampleLayer.addSublayer(pathLayer)
        pathLayer.fillColor = NSColor.clearColor().CGColor
        pathLayer.strokeColor = NSColor.grayColor().CGColor
        pathLayer.lineWidth = 2
        pathLayer.path = path
    }
    
    
    @IBAction func didPressCopyToClipboard(sender: AnyObject) {
        
        let size = self.sampleLayer.bounds.size
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
        let ctx = NSGraphicsContext.currentContext()?.CGContext
        CGContextClearRect(ctx, rect)
        CGContextSetFillColorWithColor(ctx, NSColor.clearColor().CGColor)
        self.sampleLayer.renderInContext(ctx!)
        CGContextFillRect(ctx, rect)
        
        im.unlockFocus()

        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        
        let copiesObjects = [im]
        pasteboard.writeObjects(copiesObjects)
        
        /*
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        NSArray *copiedObjects = [NSArray arrayWithObject:image];
        [pasteboard writeObjects:copiedObjects];
        */
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        
        CGPathMoveToPoint(self.path, nil, self.sampleView.convertPoint(theEvent.locationInWindow, fromView: nil).x, self.sampleView.convertPoint(theEvent.locationInWindow, fromView: nil).y)
        self.pathLayer.path = path
    }
    override func mouseUp(theEvent: NSEvent) {
        super.mouseUp(theEvent)
        
        
    }
    override func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent)
        print("moved \(theEvent.locationInWindow)")
    }
    override func mouseDragged(theEvent: NSEvent) {
        super.mouseDragged(theEvent)
        
        CGPathAddLineToPoint(self.path, nil, self.sampleView.convertPoint(theEvent.locationInWindow, fromView: nil).x, self.sampleView.convertPoint(theEvent.locationInWindow, fromView: nil).y)
        self.pathLayer.path = path
        
    }
    
    
}
 