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
  @IBOutlet weak var colorPlate: ColorPlate!
  @IBOutlet weak var lineWidthPlate: LineWidthPlate!

  @IBOutlet weak var button_copy: NSButton!
  @IBOutlet weak var button_save: NSButton!
  @IBOutlet weak var button_clear: NSButton!
  @IBOutlet weak var button_setting: NSButton!


  override func viewDidLoad() {
    super.viewDidLoad()
    let colors = [
      NSColor(calibratedRed: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1),
      NSColor(calibratedRed: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1),
      NSColor(calibratedRed: 237.0/255.0, green: 229.0/255.0, blue: 68.0/255.0, alpha: 1),
      NSColor(calibratedRed: 185.0/255.0, green: 219.0/255.0, blue: 73.0/255.0, alpha: 1),
      NSColor(calibratedRed: 226.0/255.0, green: 81.0/255.0, blue: 80.0/255.0, alpha: 1),
      NSColor(calibratedRed: 58.0/255.0, green: 230.0/255.0, blue: 226.0/255.0, alpha: 1)
    ]


    self.board.layer!.cornerRadius = 6
    self.board.layer!.backgroundColor = NSColor.whiteColor().CGColor
    self.board.layer!.shadowOpacity = 0.1
    self.board.layer!.shadowOffset = CGSizeMake(0,-2)
    self.board.layer!.shadowRadius = 4
    self.board.currentStrokeColor = colors[0]


    self.colorPlate.delegate = self
    self.colorPlate.setupColors(colors)

    self.lineWidthPlate.delegate = self


    for member in [button_copy,button_save,button_clear,button_setting]{
      member.layer = CALayer()
      member.layer?.shadowOffset = CGSizeMake(0, 2)
      member.layer?.shadowColor = NSColor.blackColor().CGColor
      member.layer?.shadowOpacity = 0.2
    }




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

  @IBAction func didPressSetting(sender: AnyObject) {
    let delegate = NSApplication.sharedApplication().delegate as! AppDelegate

    let menu = NSMenu()
    menu.addItem(NSMenuItem(title: "Change Save Path", action: #selector(delegate.presentPathChangerWindow), keyEquivalent: "m"))
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(delegate.terminateApp(_:)), keyEquivalent: "q"))


    NSMenu.popUpContextMenu(menu, withEvent: NSApp.currentEvent!, forView: self.button_setting)
  }



  @IBAction func didPressSave(sender: AnyObject) {
    //Desktop Path
    //        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DesktopDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    //        let path = paths[0]
    //Save
    let appDelegate = NSApplication.sharedApplication().delegate! as! AppDelegate

    let img = self.board.produceImage()
    img.lockFocus()
    let imgRep = NSBitmapImageRep(focusedViewRect: NSMakeRect(0.0, 0.0, img.size.width, img.size.height))
    img.unlockFocus()
    let data = imgRep!.representationUsingType(.NSJPEGFileType, properties: [:])
    data!.writeToFile(appDelegate.savingPath! + "\(NSDate().description)" + ".png", atomically: false)

  }

}

// MARK: Control Delegates
extension MainViewController:ColorPlateDelegate{
  func didSelected(color: NSColor) {
    self.board.currentStrokeColor = color
  }
}
extension MainViewController:LineWidthPlateDelegate{
  func didChange(width: CGFloat) {
    self.board.currentStrokeWidth = width
  }
}
