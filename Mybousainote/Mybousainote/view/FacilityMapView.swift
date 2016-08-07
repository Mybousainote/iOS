//
//  FacilityMapView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class FacilityMapView: GMSMapView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("地図ビューの初期化")
    }
    
    func setCameraLocation(lat: Double, lng: Double) {
        let camera = GMSCameraPosition.cameraWithLatitude(lat as CLLocationDegrees, longitude: lng as CLLocationDegrees, zoom: 15)
        self.camera = camera
    }
    
    
    func setPolyline(points: [AnyObject]) {
        let path = GMSMutablePath()
        
        var num = 0
        for point in points {
            num += 1
            let lat = point["lat"] as! Double
            let lng = point["lng"] as! Double
            
            path.addCoordinate(CLLocationCoordinate2DMake(lat, lng))
            
            
            if num == 1 {
                setCurrentMarker(lat, lng: lng)
            }
            if num == points.count {
                setMarker(lat, lng: lng)
            }
        }
        let polyline = GMSPolyline(path: path)
        
        polyline.strokeColor = UIColor(red: 0/255, green: 102/255, blue: 102/255, alpha: 1.0)
        polyline.strokeWidth = 2.0
        polyline.map = self
        
        //軌跡がおさまるズームサイズに変更する
        let bouds: GMSCoordinateBounds = GMSCoordinateBounds().includingPath(path)
        let cameraUpdate: GMSCameraUpdate = GMSCameraUpdate.fitBounds(bouds, withPadding: 30)
        self.animateWithCameraUpdate(cameraUpdate)
    }
    
    func setCurrentMarker(lat: Double, lng: Double) {
        let position = CLLocationCoordinate2DMake(lat, lng)
        let marker = GMSMarker(position: position)
        
        let pinName = "current_nav.png"
        let img: UIImage! = UIImage(named: pinName)
        marker.icon = img
        marker.groundAnchor = CGPointMake(0.5, 0.5)
        marker.map = self
    }
    
    func setMarker(lat: Double, lng: Double) {
        let position = CLLocationCoordinate2DMake(lat, lng)
        let marker = GMSMarker(position: position)
        
        let pinName = "pin_nav.png"
        let img: UIImage! = UIImage(named: pinName)
        marker.icon = img
        marker.map = self
    }
}
