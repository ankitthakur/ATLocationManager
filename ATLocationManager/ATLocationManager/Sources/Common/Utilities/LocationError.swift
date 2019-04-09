//
//  LocationError.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 08/04/19.
//

import Foundation

public struct LocationError: Error {
    enum ErrorKind {
        case noAddress
        case reverseGeocode
        case noLocationFound
    }
    let kind: ErrorKind
    let message:String
}
