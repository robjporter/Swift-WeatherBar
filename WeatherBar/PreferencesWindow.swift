//
//  PreferencesWindow.swift
//  WeatherBar
//
//  Created by Rob Porter on 24/10/2017.
//  Copyright © 2017 Rob Porter. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController,NSWindowDelegate {
    @IBOutlet weak var cityTextField: NSTextField!
    
    var delegate: PreferencesWindowDelegate?
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        let defaults = UserDefaults.standard
        let city = defaults.string(forKey: "city") ?? DEFAULT_CITY
        cityTextField.stringValue = city
    }
    
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(cityTextField.stringValue, forKey: "city")
        delegate?.preferencesDidUpdate()
    }
    
}
