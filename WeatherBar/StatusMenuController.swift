//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Rob Porter on 24/10/2017.
//  Copyright © 2017 Rob Porter. All rights reserved.
//

import Cocoa

let DEFAULT_CITY = "Wellingborough, UK"

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var weatherView: WeatherView!
    
    var weatherMenuItem: NSMenuItem!
    var preferencesWindow: PreferencesWindow!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let weatherAPI = WeatherAPI()
    
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func updateWeather(_ sender: NSMenuItem) {
        internalUpdateWeather()
    }
    
    func internalUpdateWeather() {
        let defaults = UserDefaults.standard
        let city = defaults.string(forKey: "city") ?? DEFAULT_CITY
        weatherAPI.fetchWeather(city) { weather in
            self.weatherView.update(weather)
        }
    }
    
    func preferencesDidUpdate() {
        internalUpdateWeather()
    }
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        weatherMenuItem=statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        internalUpdateWeather()
    }}
