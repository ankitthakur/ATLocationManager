//
//  LocationTriggerManager.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 09/04/19.
//

import Foundation
import CoreLocation

internal final class LocationTriggerManager: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    let accurateLocations = [kCLLocationAccuracyBest,
                             kCLLocationAccuracyBestForNavigation,
                             kCLLocationAccuracyNearestTenMeters]

    static let shared = LocationTriggerManager()

    //Initializer access level change now
    fileprivate override init() {}

    func startMonitoring() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
        if CLLocationManager.locationServicesEnabled() {
            #if os(iOS)
            locationManager?.startMonitoringVisits()
            locationManager?.startMonitoringSignificantLocationChanges()
            print("\(self) -> Function: \(#function) -> startMonitoringVisits")
            print("\(self) -> Function: \(#function) -> startMonitoringSignificantLocationChanges")
            #elseif os(macOS) || os(OSX)
            locationManager?.startMonitoringSignificantLocationChanges()
            print("\(self) -> Function: \(#function) -> startMonitoringVisits")
            print("\(self) -> Function: \(#function) -> startMonitoringSignificantLocationChanges")
            #endif
        }
    }

    func stopMonitoring() {

        if CLLocationManager.locationServicesEnabled() {
            #if os(iOS)
            locationManager?.stopMonitoringVisits()
            locationManager?.stopMonitoringSignificantLocationChanges()
            print("\(self) -> Function: \(#function) -> stopMonitoringVisits")
            print("\(self) -> Function: \(#function) -> stopMonitoringSignificantLocationChanges")
            #elseif os(macOS) || os(OSX)
            locationManager?.stopMonitoringSignificantLocationChanges()
            print("\(self) -> Function: \(#function) -> startMonitoringSignificantLocationChanges")
            #endif
        }
    }

    class func isLocationPermissionAlreadyGranted() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            #if os(iOS)
            if  CLLocationManager.authorizationStatus() == .authorizedAlways ||
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                return true
            }
            #elseif os(macOS) || os(OSX)
            if #available(OSX 10.12, *) {
                if  CLLocationManager.authorizationStatus() == .authorizedAlways ||
                    CLLocationManager.authorizationStatus() == .authorized {
                    return true
                }
            } else {
                if  CLLocationManager.authorizationStatus() == .authorized {
                    return true
                }
            }
            #endif

        }
        return false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            // start trigger
            LocationManager.shared.capture(withEvent: .significant)
            
        }
    }
    #if os(iOS)
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        if visit.arrivalDate != Date.distantPast && visit.departureDate != Date.distantFuture {
            LocationManager.shared.capture(withEvent: .visit)

        } else if visit.arrivalDate != Date.distantPast {
            LocationManager.shared.capture(withEvent: .visit)

        } else {
            print("\(self) -> Function: \(#function) -> unknown visit :\(visit)")
        }
    }
    #endif
}
