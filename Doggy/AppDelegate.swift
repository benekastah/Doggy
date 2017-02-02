//
//  AppDelegate.swift
//  Doggy
//
//  Created by Paul Harper on 12/8/16.
//  Copyright © 2016 Paul Harper. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var statusItem: NSStatusItem!
    var darkModeOn = false
    
    var leftPressed = false;
    var rightPressed = false;
    var upPressed = false;
    var downPressed = false;
    var shiftPressed = false;
    var timer: Timer?;
    
    let xPosIncrement = 4.0 / 13.0;
    let xNormalSize = 5.0 / 13.0;
    let xLargeSize = 9.0 / 13.0;
    
    let yPosIncrement = 6.0 / 13.0;
    let ySize = 7.0 / 13.0;

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        let img = Bundle.main.pathForImageResource("Doggy-16")
        self.statusItem.image = NSImage.init(byReferencingFile: img!)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Left", action: #selector(self.pullLeft(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Left (big)", action: #selector(self.pullLeftBig(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Middle", action: #selector(self.pullMiddle(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Right", action: #selector(self.pullRight(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Right (big)", action: #selector(self.pullRightBig(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Full screen", action: #selector(self.fullScreen(sender:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(self.quit(sender:)), keyEquivalent: "q"))
        
        self.statusItem.menu = menu
        
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        AXIsProcessTrustedWithOptions(options)
        setUpGlobalEvents()
    }
    
    func setUpGlobalEvents() -> Void {
        if AXIsProcessTrusted() {
            NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyUp.union(NSEventMask.flagsChanged),
                                              handler: handleGlobalEvents)
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(_: Timer) in self.setUpGlobalEvents()})
        }
    }
    
    func handleGlobalEvents(event: NSEvent) {
        let command = event.modifierFlags.contains(NSEventModifierFlags.command)
        let control = event.modifierFlags.contains(NSEventModifierFlags.control)
        if command && control {
            shiftPressed = shiftPressed || event.modifierFlags.contains(NSEventModifierFlags.shift)
            upPressed = upPressed || event.keyCode == 126
            rightPressed = rightPressed || event.keyCode == 124
            downPressed = downPressed || event.keyCode == 125
            leftPressed = leftPressed || event.keyCode == 123
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: delayedHandleGlobalEvents)
        }
    }
    
    func delayedHandleGlobalEvents(t: Timer) {
        if shiftPressed {
            if leftPressed {
                pullLeftBig(sender: self)
            } else if rightPressed {
                pullRightBig(sender: self)
            } else if upPressed {
                pullMiddleTop(sender: self)
            } else if downPressed {
                pullMiddleBottom(sender: self)
            }
        } else if leftPressed && downPressed {
            pullLeftBottom(sender: self)
        } else if leftPressed && upPressed {
            pullLeftTop(sender: self)
        } else if leftPressed {
            pullLeft(sender: self)
        } else if rightPressed && downPressed {
            pullRightBottom(sender: self)
        } else if rightPressed && upPressed {
            pullRightTop(sender: self)
        } else if rightPressed {
            pullRight(sender: self)
        } else if upPressed {
            fullScreen(sender: self)
        } else if downPressed {
            pullMiddle(sender: self)
        }
    
        shiftPressed = false
        leftPressed = false
        rightPressed = false
        downPressed = false
        upPressed = false
    }
    
    func quit(sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func positionWindows(x: Double, y: Double, width: Double, height: Double) {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        let script = Bundle.main.path(forResource: "position-window", ofType: "scpt")!
        let args = [x, y, width, height].map({String($0)});
        task.arguments = [script] + args;
        task.launch()
    }
    
    func pullLeft(sender: AnyObject) {
        positionWindows(x: 0, y: 0, width: self.xNormalSize, height: 1)
    }
    
    func pullLeftTop(sender: AnyObject) {
        positionWindows(x: 0, y: 0, width: self.xNormalSize, height: self.ySize)
    }
    
    func pullLeftBottom(sender: AnyObject) {
        positionWindows(x: 0, y: self.yPosIncrement, width: self.xNormalSize, height: self.ySize)
    }
    
    func pullMiddle(sender: AnyObject) {
        positionWindows(x: self.xPosIncrement, y: 0, width: self.xNormalSize, height: 1)
    }
    
    func pullMiddleTop(sender: AnyObject) {
        positionWindows(x: self.xPosIncrement, y: 0, width: self.xNormalSize, height: self.ySize)
    }
    
    func pullMiddleBottom(sender: AnyObject) {
        positionWindows(x: self.xPosIncrement, y: self.yPosIncrement, width: self.xNormalSize, height: self.ySize)
    }
    
    func pullRight(sender: AnyObject) {
        positionWindows(x: 2 * self.xPosIncrement, y: 0, width: self.xNormalSize, height: 1)
    }
    
    func pullRightTop(sender: AnyObject) {
        positionWindows(x: 2 * self.xPosIncrement, y: 0, width: self.xNormalSize, height: self.ySize)
    }
    
    func pullRightBottom(sender: AnyObject) {
        positionWindows(x: 2 * self.xPosIncrement, y: self.yPosIncrement, width: self.xNormalSize, height: self.ySize)
    }
    
    func pullLeftBig(sender: AnyObject) {
        positionWindows(x: 0, y: 0, width: self.xLargeSize, height: 1)
    }
    
    func pullRightBig(sender: AnyObject) {
        positionWindows(x: self.xPosIncrement, y: 0, width: self.xLargeSize, height: 1)
    }
    
    func fullScreen(sender: AnyObject) {
        positionWindows(x: 0, y: 0, width: 1, height: 1)
    }
}

