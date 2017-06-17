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

  let statusItem = NSStatusBar.system().statusItem(withLength: -2)
  let popover = NSPopover()

  var eventMonitor: EventMonitor?


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application

    if let button = statusItem.button {
      button.image = NSImage(named: "StatusBarButtonImage")
      button.action = #selector(AppDelegate.togglePopover(_:))
    }
    //disable popover animation
    popover.animates = false
    popover.contentViewController = MainViewController(nibName: "MainViewController", bundle: nil)


    self.eventMonitor = EventMonitor(mask: [.leftMouseDown,.rightMouseDown]) { [unowned self] event in
      if self.popover.isShown {
        self.closePopover(event)
      }
    }
    eventMonitor?.start()



    // set default saving path
    if(self.savingPath == nil){
      self.savingPath = "/Users/\(NSUserName())/Desktop"
    }

  }




  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }



  func showPopover(_ sender: AnyObject?) {
    if let button = statusItem.button {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
    self.eventMonitor?.start()
  }

  func closePopover(_ sender: AnyObject?) {
    popover.performClose(sender)
    self.eventMonitor?.stop()
  }

  func togglePopover(_ sender: AnyObject?) {
    if popover.isShown {
      closePopover(sender)
    } else {
      showPopover(sender)
    }
  }







  //global
  func terminateApp(_ sender:AnyObject){
    NSApplication.shared().terminate(nil)
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
    panel.begin { (result) in
      if(result == NSFileHandlingPanelOKButton){
        let urls = panel.urls
        let path = urls[0].path
        self.savingPath = path
      }
    }
  }

  var savingPath:String? {
    get{
      if let path = UserDefaults.standard.string(forKey: "SavingPath") {
        return path
      } else {
        return nil
      }
    }
    set(newValue){
      UserDefaults.standard.setValue(newValue! + "/", forKey: "SavingPath")
    }
  }


}

