//
//  LocationConfiguration.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 09/04/19.
//

import Foundation

public struct LocationConfiguration {
     /// time out interval for reverse geocoding in seconds. default is 10 seconds
     static var geocodeTimeout = 10.0

    public mutating func setGeocodeTimeout(_ timeout:Double?) {
        if let geoTimeout = timeout {
            if geoTimeout <= 0 {
                print("geocode timeout cannot be less than 1")
            }
            else {
                LocationConfiguration.geocodeTimeout = geoTimeout
            }
        }
    }
}
