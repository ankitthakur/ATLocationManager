//
//  ViewController.swift
//  ATLocationManagerExample-iOS
//
//  Created by Ankit Thakur on 08/04/19.
//  Copyright © 2019 Ankit Thakur. All rights reserved.
//

import UIKit
import ATLocationManager

class ViewController: UIViewController, LocationManagerDelegate {
    func didUpdate(location: Location) {
        print("location:\(location.eventName!)")
    }

    func didFailLocation(error: LocationError) {
        print(error)
    }

    func didUpdateAuthorization(success: Bool) {
        print("authentication:\(success)")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LocationManager.shared.initializeCapture(delegate: self, withEvent: .hostApp)

        LocationManager.shared.initializeTrigger(delegate: self)
    }


}

