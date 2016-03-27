//
//  MainViewController.swift
//  Freehand
//
//  Created by Carrl on 16/3/26.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var board: Board!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.board.layer!.cornerRadius = 6
        self.board.layer!.backgroundColor = NSColor.whiteColor().CGColor
        self.board.layer!.shadowOpacity = 0.1
        self.board.layer!.shadowOffset = CGSizeMake(0,-2)
        self.board.layer!.shadowRadius = 4
        

        // Do view setup here.
    }
    
    
    
    @IBAction func didPressClear(sender: AnyObject) {
        self.board.clearboard()
    }
    
    @IBAction func didPressCopyToClipboard(sender: AnyObject) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        let copiesObjects = [self.board.produceImage()]
        pasteboard.writeObjects(copiesObjects)
    }
    
    
}
 