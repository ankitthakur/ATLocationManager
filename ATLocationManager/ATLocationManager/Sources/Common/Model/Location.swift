//
//  Location.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 08/04/19.
//

import Foundation
import CoreLocation


/// Represents the geographical coordinate along with accuracy, timestamp, address information with type of event when captured.
public struct Location: Codable {

    /// Type used to represent a latitude or longitude coordinate in degrees under the WGS 84 reference
    /// frame. The degree can be positive (North and East) or negative (South and West).
    var latitude: Double?

    /// Type used to represent a latitude or longitude coordinate in degrees under the WGS 84 reference
    /// frame. The degree can be positive (North and East) or negative (South and West).
    var longitude: Double?

    /// The altitude of the location. Can be positive (above sea level) or negative (below sea level).
    var altitude: Double?

    /// Type used to represent a location accuracy level in meters. The lower the value in meters, the
    /// more physically precise the location is. A negative accuracy value indicates an invalid location.
    var horizontalAccuracy: Double?

    /// Type used to represent a location accuracy level in meters. The lower the value in meters, the
    /// more physically precise the location is. A negative accuracy value indicates an invalid location.
    var verticalAccuracy: Double?

    /// Type used to represent the direction in degrees from 0 to 359.9
    var direction: Double?

    /// Type used to represent the speed in meters per second.
    var speed: Double?

    /// The address of the location as per CLGeocoded dictionary
    var address:String?

    /// The timestamp, when location is captured
    var timestamp: Date = Date()

    /// The name of the event, during which process the location is captured.
    var eventName: String?

    internal init(inputLocation: CLLocation, inputEventName:String, inputAddress: String) {
        self.latitude = inputLocation.coordinate.latitude
        self.longitude = inputLocation.coordinate.longitude
        self.altitude = inputLocation.altitude
        self.horizontalAccuracy = inputLocation.horizontalAccuracy
        self.verticalAccuracy = inputLocation.verticalAccuracy
        self.direction = inputLocation.course
        self.speed = inputLocation.speed
        self.address = inputAddress
        self.timestamp = Date()
        self.eventName = inputEventName


    }

    internal enum LocationKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case horizontalAccuracy
        case verticalAccuracy
        case direction
        case speed
        case address
        case timestamp
        case eventName
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationKeys.self)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        altitude = try container.decodeIfPresent(Double.self, forKey: .altitude)
        horizontalAccuracy = try container.decodeIfPresent(Double.self, forKey: .horizontalAccuracy)
        verticalAccuracy = try container.decodeIfPresent(Double.self, forKey: .verticalAccuracy)
        direction = try container.decodeIfPresent(Double.self, forKey: .direction)
        speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        timestamp = Date(timeIntervalSince1970: TimeInterval(Double(try container.decodeIfPresent(Int64.self, forKey: .timestamp)) ?? 0.0))
        eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: LocationKeys.self)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(altitude, forKey: .altitude)
        try container.encodeIfPresent(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encodeIfPresent(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encodeIfPresent(direction, forKey: .direction)
        try container.encodeIfPresent(speed, forKey: .speed)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(timestamp.timeIntervalSince1970, forKey: .timestamp)
        try container.encodeIfPresent(eventName, forKey: .eventName)
    }
}
