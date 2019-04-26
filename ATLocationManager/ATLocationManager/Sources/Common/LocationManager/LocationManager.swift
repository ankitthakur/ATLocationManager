//
//  LocationManager.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 09/04/19.
//

import Foundation
import CoreLocation

public protocol LocationManagerDelegate: AnyObject {
    func didUpdate(location: Location)
    func didFailLocation(error: LocationError)
    func didUpdateAuthorization(success: Bool)
}

final public class LocationManager: NSObject, CLLocationManagerDelegate {

    public static let shared = LocationManager()

    //Initializer access level change now
    fileprivate override init() {}

    var locationManager: CLLocationManager?
    let accurateLocations = -65...65
    weak var locationDelegate: LocationManagerDelegate?
    var event:LocationEventType?
    private var locationTrigger:LocationTriggerManager = LocationTriggerManager.shared


    public func initializeTrigger(delegate: LocationManagerDelegate?) {
        locationTrigger.startMonitoring()
    }

    public func initializeCapture(delegate: LocationManagerDelegate?, withEvent event:LocationEventType) {
        locationDelegate = delegate
        self.event = event

        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            #if os(iOS)
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.requestAlwaysAuthorization()
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.pausesLocationUpdatesAutomatically = false
            #endif


            print("\(type(of: self)) -> Function: \(#function) -> requested location - locationServicesEnabled - \(String(describing: locationManager))")
            if CLLocationManager.locationServicesEnabled() {

                print("\(type(of: self)) -> Function: \(#function) -> requesting location - \(String(describing: accurateLocations))")
                locationManager?.stopUpdatingLocation()
                #if os(iOS)
                locationManager?.requestLocation()
                #elseif os(macOS) || os(OSX)
                if #available(OSX 10.14, *) {
                    locationManager?.requestLocation()
                } else {
                    locationManager?.startUpdatingLocation()
                }
                #endif

            } else {
                locationDelegate?.didFailLocation(error: .authorization)
            }
        }

    }

    internal func capture(withEvent event:LocationEventType) {
        self.event = event

        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            #if os(iOS)
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.requestAlwaysAuthorization()
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.pausesLocationUpdatesAutomatically = false
            #endif


            print("\(type(of: self)) -> Function: \(#function) -> requested location - locationServicesEnabled - \(String(describing: locationManager))")
            if CLLocationManager.locationServicesEnabled() {

                print("\(type(of: self)) -> Function: \(#function) -> requesting location - \(String(describing: accurateLocations))")
                locationManager?.stopUpdatingLocation()
                #if os(iOS)
                locationManager?.requestLocation()
                #elseif os(macOS) || os(OSX)
                if #available(OSX 10.14, *) {
                    locationManager?.requestLocation()
                } else {
                    locationManager?.startUpdatingLocation()
                }
                #endif

            } else {
                locationDelegate?.didFailLocation(error: .authorization)
            }
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

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        var locationError: LocationError = .noLocationFound

        if let clerror = error as? CLError {

            switch clerror.code {
            case .locationUnknown:
                locationError = .noLocationFound
            case .denied:
                locationError = .authorization
            case .network:
                locationError = .noLocationFound
            default:
                locationError = .timedOut
            }
        }
        print(error)
        locationDelegate?.didFailLocation(error: locationError)
    }

    fileprivate func processGeocode(_ location: CLLocation) {
        Geocoder().geocode(location: location, queue: .main, eventType: self.event!) { (location, address, error, event) -> (Void) in
            let loc = Location(inputLocation: location!, inputEventName: self.event!.rawValue, inputAddress: address!)
            self.locationDelegate?.didUpdate(location: loc)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(type(of: self)) -> Function: \(#function) -> didUpdateLocations called: \(locations)")
        if let location = locations.last {
            if locationManager != nil {
                // if got actual location, then stop updating location and nullify the manager
                locationManager?.stopUpdatingLocation()
                locationManager = nil

                processGeocode(location)

            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        #if os(iOS)
        if  status == .authorizedAlways ||
            status == .authorizedWhenInUse {
            locationDelegate?.didUpdateAuthorization(success: true)
        }
        #elseif os(macOS) || os(OSX)
        if #available(OSX 10.12, *) {
            if  status == .authorizedAlways ||
                status == .authorized {
                locationDelegate?.didUpdateAuthorization(success: true)
            }
        } else {
            if  status == .authorized {
                locationDelegate?.didUpdateAuthorization(success: true)
            }
        }
        #endif

    }
}
