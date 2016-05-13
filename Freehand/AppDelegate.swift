//
//  AppDelegate.swift
//  Freehand
//
//  Created by Carrl on 16/3/26.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    lazy var changePathWindowController: ChangePathWindowController = ChangePathWindowController(windowNibName: "ChangePathWindowController")
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        //disable popover animation
        popover.animates = false
        popover.contentViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        
        self.eventMonitor = EventMonitor(mask: [.LeftMouseDownMask,.RightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
        
        
        
        // set default saving path
        if(self.savingPath == nil){
            self.savingPath = "/Users/\(NSUserName())/Desktop"
        }
        
    }
    
    
    

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        self.eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        self.eventMonitor?.stop()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    
    
    
    
    
    
    //global
    func terminateApp(sender:AnyObject){
        NSApplication.sharedApplication().terminate(nil)
    }
    
    
    // TODO: change path
    func presentPathChangerWindow(){
//        self.changePathWindowController.showWindow(self)
//        NSApp.activateIgnoringOtherApps(true)
//        self.changePathWindowController.window!.makeKeyAndOrderFront(nil)
        
        self.togglePopover(nil)
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.beginWithCompletionHandler { (result) in
            if(result == NSFileHandlingPanelOKButton){
                let urls = panel.URLs
                let path = urls[0].path!
                self.savingPath = path
            }
        }
    }
    
    var savingPath:String?{
        get{
            let path = NSUserDefaults.standardUserDefaults().stringForKey("SavingPath")! + "/"
            return path
        }
        set(newValue){
            NSUserDefaults.standardUserDefaults().setValue(newValue! + "/", forKey: "SavingPath")
        }
    }
    
    
}

