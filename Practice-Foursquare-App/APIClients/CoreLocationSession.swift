//
//  CoreLocationSession.swift
//  Practice-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationSession: NSObject {
    
    public var locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // the following keys need to be added to the info.plist file
        // NSLocationAlwaysAndWhenInUseUsageDescription
        // NSLocationWhenInUseUsageDescription
        
        // get updates for user location
        
        // more aggressive
//        locationManager.startUpdatingLocation()
        
        // less aggressive
//        startSignificantLocationChanges()
//        
//        startMonitoringRegion()
    }
    
    private func startSignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // not available on the device
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D) {
        // we will use the CLGeocoder() class for converting coordinate (CLLocationCoordinate2D) to (CLPlacemark)
        
        // we need to create a CLLocation
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("reverseGeocodeLocation error: \(error)")
            }
            if let firstPlacemark = placemarks?.first {
                print("placemark info: \(firstPlacemark)")
            }
        }
    }
    
    public func convertPlacemarkToCoordinate(addressString: String) {
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                print("geocodeAddressString error: \(error)")
            }
            if let firstPlacemark = placemarks?.first, let location = firstPlacemark.location {
                print("coordinate info: \(location.coordinate)")
            }
        }
    }
    
    // monitor a CLRegion
    
    
}

extension CoreLocationSession: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion \(region)")
    }
}
