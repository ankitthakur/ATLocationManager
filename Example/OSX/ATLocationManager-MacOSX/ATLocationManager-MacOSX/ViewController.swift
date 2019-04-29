//
//  ViewController.swift
//  ATLocationManager-MacOSX
//
//  Created by Ankit Thakur on 08/04/19.
//  Copyright © 2019 Ankit Thakur. All rights reserved.
//

import Cocoa
import ATLocationManager
import CoreLocation

class ViewController: NSViewController, LocationManagerDelegate {
    func didUpdate(location: Location) {
        print("get Location - \(location.eventName)")
    }

    func didUpdateAuthorization(success: Bool) {
        print("authorization:\(success)")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.shared.initializeCapture(delegate: self, withEvent: .hostApp)

        LocationManager.shared.initializeTrigger(delegate: self)

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func didFailLocation(error: LocationError) {
        print(error)
    }

    func didUpdate(location clLocation: CLLocation) {
        print(clLocation)
    }


}

