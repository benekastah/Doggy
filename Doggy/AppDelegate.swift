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
    
    var commandPressed = false;
    var controlPressed = false;
    var shiftPressed = false;
    var leftPressed = false;
    var rightPressed = false;
    var downPressed = false;
    var upPressed = false;


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
        
        if (!AXIsProcessTrusted()) {
            let alert = NSAlert()
            alert.messageText = "Doggy doesn't have accessibility enabled. Keyboard shortcuts won't work without it. Go to System Preferences > Security & Privacy > Privacy > Accessibility to enable it."
            let img = Bundle.main.pathForImageResource("Doggy-128")
            alert.icon = NSImage.init(byReferencingFile: img!)
            alert.runModal()
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyDown.union(NSEventMask.flagsChanged),
                                          handler: {(event) in self.handleGlobalEvents(event: event, pressed: true)})
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyUp.union(NSEventMask.flagsChanged),
                                          handler: {(event) in self.handleGlobalEvents(event: event, pressed: false)})
    }
    
    func handleGlobalEvents(event: NSEvent, pressed: Bool) {
        commandPressed = event.modifierFlags.contains(NSEventModifierFlags.command)
        controlPressed = event.modifierFlags.contains(NSEventModifierFlags.control)
        shiftPressed = event.modifierFlags.contains(NSEventModifierFlags.shift)
        if event.keyCode == 123 {
            leftPressed = pressed;
        } else if event.keyCode == 124 {
            rightPressed = pressed;
        } else if event.keyCode == 125 {
            downPressed = pressed;
        } else if event.keyCode == 126 {
            upPressed = pressed;
        }
        
        if commandPressed && controlPressed {
            if leftPressed {
                if shiftPressed {
                    pullLeftBig(sender: self)
                } else {
                    pullLeft(sender: self)
                }
                leftPressed = false;
            } else if downPressed {
                pullMiddle(sender: self)
                downPressed = false
            } else if rightPressed {
                if shiftPressed {
                    pullRightBig(sender: self)
                } else {
                    pullRight(sender: self)
                }
                rightPressed = false
            } else if upPressed {
                fullScreen(sender: self)
                upPressed = false
            }
        }
    }
    
    func quit(sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func positionWindows(segment: Int, size: Int, numSegments: Int) {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        let script = Bundle.main.path(forResource: "position-window", ofType: "scpt")!
        task.arguments = [script, String(segment), String(size), String(numSegments)]
        task.launch()
    }
    
    func pullLeft(sender: AnyObject) {
        positionWindows(segment: 0, size: 1, numSegments: 3)
    }
    
    func pullMiddle(sender: AnyObject) {
        positionWindows(segment: 1, size: 1, numSegments: 3)
    }
    
    func pullRight(sender: AnyObject) {
        positionWindows(segment: 2, size: 1, numSegments: 3)
    }
    
    func pullLeftBig(sender: AnyObject) {
        positionWindows(segment: 0, size: 2, numSegments: 3)
    }
    
    func pullRightBig(sender: AnyObject) {
        positionWindows(segment: 1, size: 2, numSegments: 3)
    }
    
    func fullScreen(sender: AnyObject) {
        positionWindows(segment: 0, size: 1, numSegments: 1)
    }
}

