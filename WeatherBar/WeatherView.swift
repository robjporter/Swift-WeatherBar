//
//  WeatherView.swift
//  WeatherBar
//
//  Created by Rob Porter on 24/10/2017.
//  Copyright © 2017 Rob Porter. All rights reserved.
//

import Cocoa

class WeatherView: NSView {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var currentConditionsTextField: NSTextField!
   
    func update(_ weather: Weather) {
        DispatchQueue.main.async {
            self.cityTextField.stringValue = weather.city
            self.currentConditionsTextField.stringValue = "\(Int(weather.currentTemp))°F and \(weather.conditions)"
            self.imageView.image = NSImage(named: weather.icon)
        }
    }
}
