//
//  LocationManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func aquiredCityName(cityName: String, lat: Double, lng: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var delegate: LocationManagerDelegate!
    
    var lat: CLLocationDegrees = 0
    var lng: CLLocationDegrees = 0
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        locationManager.delegate = self
        //位置情報の精度
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    //位置情報許可のリクエスト
    func requestAuthorization() {
        print("位置情報許可のリクエスト")        
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            if #available(iOS 8.0, *) {
                locationManager.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
            }
        }
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    //位置情報の取得を開始する
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("認証状態の変更");
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
//            locationManager.startUpdatingLocation()
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print("CLAuthorizationStatus: \(statusStr)")
    }
    
    // 位置情報が取得できたとき
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0{
            if let currentLocation = (locations.last as? CLLocation?) {
                lat = (currentLocation?.coordinate.latitude)!
                lng = (currentLocation?.coordinate.longitude)!
            
//                print("緯度:\(lat) 経度:\(lng)")
                
                //テスト用
                //渋谷
//                lat = 35.659500
//                lng = 139.699554
                //北海道
                lat = 43.064615
                lng = 141.346807
                
                
                //データベースに保存
                appDelegate.dbManager.insertLocationTable(lat, lng: lng)
            }
        }
    }
    
    // 位置情報取得に失敗したとき
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("locationManager error：", terminator: "")
    }
    
    //緯度経度から地名取得
    func revGeocoding(lat: Double, lng: Double) {
        let location = CLLocation(latitude: lat, longitude: lng)
        
        var locality: String = ""
        var subLocality: String = ""
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            if error != nil {
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                //stop updating location to save battery life
//                print("Country = \(placemark.country)")
//                print("Postal Code = \(placemark.postalCode)")
//                print("Administrative Area = \(placemark.administrativeArea)")
//                print("Sub Administrative Area = \(placemark.subAdministrativeArea)")
//                print("Locality = \(placemark.locality)")
//                print("Sub Locality = \(placemark.subLocality)")
//                print("Throughfare = \(placemark.thoroughfare)")
                
                locality = placemark.locality!
                subLocality = placemark.subLocality!
                
                //取得した地名をDatabaseManagerの方で保存する
                self.delegate.aquiredCityName(locality+subLocality, lat: lat, lng: lng)
                
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    
    
}
