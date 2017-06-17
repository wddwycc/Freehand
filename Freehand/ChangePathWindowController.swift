//
//  ChangePathWindowController.swift
//  Freehand
//
//  Created by Carrl on 16/5/13.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class ChangePathWindowController: NSWindowController {
    
    @IBOutlet weak var textField: NSTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        //hide the status bar 
        self.window!.styleMask = NSBorderlessWindowMask
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    @IBAction func didPressChoose(_ sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin { (result) in
            if(result == NSFileHandlingPanelOKButton){
                let urls = panel.urls
                let path = urls[0].path
                self.textField.stringValue = path
            }
        }
    }
    
    @IBAction func didPressConfirm(_ sender: AnyObject) {
        self.window!.close()
        
    }
    
}
