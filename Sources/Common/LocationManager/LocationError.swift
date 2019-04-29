//
//  LocationError.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 08/04/19.
//

import Foundation


/// List of errors happened during location capture process.
public enum LocationError: Error {
    case noAddress
    case reverseGeocode
    case noLocationFound
    case authorization
    case timedOut
}
