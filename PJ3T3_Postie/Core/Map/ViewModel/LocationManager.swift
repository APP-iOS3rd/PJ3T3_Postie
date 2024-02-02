//
//  LocationManager.swift
//  PJ3T3_Postie
//
//  Created by kwon ji won on 2/1/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var isUpdatingLocation: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
            locationManager.requestLocation()
        }
    
    func getCurrentLocation() {
        // 현재 위치를 일회성으로 전달
        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
        locationManager.startUpdatingLocation()
        location = locationManager.location
    }
//    
    func startUpdatingLocation() {
        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1423750-startupdatinglocation
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1423695-stopupdatinglocation
        isUpdatingLocation = false
        locationManager.stopUpdatingLocation()
    }
    
    // 지속적으로 위치 데이터 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    // 오류 처리: 문제가 있으면 오류를 출력
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
