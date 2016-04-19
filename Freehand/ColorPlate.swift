//
//  ColorPlate.swift
//  Freehand
//
//  Created by Carrl on 16/3/27.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

//height: 66 width: 16*(n-1) + 40*n + 24*2
protocol ColorPlateDelegate:class{
    func didSelected(color:NSColor)
}

class ColorPlate: NSView {
    let scrollView = NSScrollView()
    private var colors = Array<NSColor>()
    
    weak var delegate: ColorPlateDelegate?
    
    var allColorViews = Array<NSView>()
    
    init(colors:Array<NSColor>){
        super.init(frame: NSRect())
        self.setup()
        self.setupColors(colors)
    }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    func setup(){
        self.addSubview(self.scrollView)
        self.scrollView.frame = self.bounds
        self.scrollView.backgroundColor = NSColor(calibratedRed: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
        self.scrollView.layer = CALayer()
        self.scrollView.layer?.cornerRadius = 8
        self.scrollView.layer?.masksToBounds = true
        
        self.layer = CALayer()
        self.layer?.shadowOffset = NSSize(width: 0, height: -2)
        self.layer?.shadowRadius = 4
        self.layer?.shadowOpacity = 0.1
        
    }
    
    
    internal func setupColors(colors:Array<NSColor>){
        self.colors = colors
        let targetWidth = 16 * (colors.count - 1) + 40 * (colors.count) + 24*2
        self.scrollView.documentView = NSView(frame: NSRect(x: 0, y: 0, width: targetWidth, height: 66))
        self.allColorViews.removeAll()
        
        for  i in 0 ..< self.colors.count {
            let currentView = NSView(frame: NSRect(x: 20 + i * 56, y: 13, width: 40, height: 40))
            self.scrollView.addSubview(currentView)
            currentView.layer = CALayer()
            currentView.layer!.cornerRadius = 12
            currentView.layer!.backgroundColor = self.colors[i].CGColor
            currentView.layer!.shadowRadius = 4
            currentView.layer!.shadowOffset = NSSize(width: 0, height: -4)

            
            self.allColorViews.append(currentView)
            let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(ColorPlate.handleClick(_:)))
            currentView.addGestureRecognizer(clickGesture)
            
            
            //default: first
            if(i == 0){
                currentView.layer!.shadowOpacity = 0.4
                self.delegate?.didSelected(self.colors.first!)
            }
            
        }
        
    }
    func handleClick(gesture:NSClickGestureRecognizer){
        if(gesture.state == NSGestureRecognizerState.Ended){
            for member in self.allColorViews{
                member.layer!.shadowOpacity = 0
            }
            gesture.view!.layer!.shadowOpacity = 0.4
            self.delegate?.didSelected(NSColor(CGColor: gesture.view!.layer!.backgroundColor!)!)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
