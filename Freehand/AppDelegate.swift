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

  let statusItem = NSStatusBar.system().statusItem(withLength: -2)
  let popover = NSPopover()

  var eventMonitor: EventMonitor?


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let button = statusItem.button {
      button.image = NSImage(named: "_icon_status_bar")
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

    if(self.savingPath == nil){
      self.savingPath = "/Users/\(NSUserName())/Desktop"
    }
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

  func presentPathChangerWindow(){
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

