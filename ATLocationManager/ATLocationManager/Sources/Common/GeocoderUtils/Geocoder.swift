//
//  File.swift
//  ATLocationManager
//
//  Created by Ankit Thakur on 09/04/19.
//

import Foundation
import CoreLocation

internal typealias GeocoderCallback =  (_ location:CLLocation?, _ address:String?,  _ error:LocationError?, _ eventType:LocationEventType?)->(Void)

internal class Geocoder {

    var userLocation:CLLocation?
    var locationCallback: GeocoderCallback?
    var geoCoder:CLGeocoder?
    var address:String = ""
    var event:LocationEventType?
    var locationError:LocationError?

    func geocode(location:CLLocation, queue:DispatchQueue, eventType:LocationEventType, callBack:@escaping GeocoderCallback){

        userLocation = location
        locationCallback = callBack
        event = eventType

        geoCoder = CLGeocoder()


        let group: DispatchGroup = DispatchGroup()

        group.enter()

        let timeout:DispatchTime = DispatchTime.now()+LocationConfiguration.geocodeTimeout

        geoCoder?.reverseGeocodeLocation(userLocation!, completionHandler: { (placemarks:[CLPlacemark]?, error:Error?) in

            if error != nil {
                print("Reverse geocoder failed with error: \(error!.localizedDescription)")
                self.locationError = LocationError(kind: .reverseGeocode, message: (error?.localizedDescription)!)
            }
            if let placemarks = placemarks , placemarks.count > 0 {
                let placemark = placemarks[0]
                self.address = self.formalizedPlace(placemark: placemark)

            } else {
                self.locationError = LocationError(kind: .noAddress, message: "no placemark is found")
            }
            group.leave()
        })

        _ = group.wait(timeout: timeout)


        group.notify(queue: queue) {
            queue.async {
                self.locationCallback!(self.userLocation, self.address, nil, self.event)
            }
        }


    }

    func formalizedPlace(placemark: CLPlacemark) -> String {
        var addressString: String = ""
        if placemark.subLocality != nil {
            addressString += placemark.subLocality! + ", "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.subThoroughfare != nil {
            addressString +=  placemark.subThoroughfare! + ", "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.subAdministrativeArea != nil {
            addressString += placemark.subAdministrativeArea! + ", "
        }
        if placemark.country != nil {
            addressString += placemark.country! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        return addressString
    }

}
