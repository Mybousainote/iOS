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
        
        for point in points {
            let lat = point["lat"] as! Double
            let lng = point["lng"] as! Double
            
            path.addCoordinate(CLLocationCoordinate2DMake(lat, lng))
        }
        let polyline = GMSPolyline(path: path)
        
        polyline.map = self
        
        let bouds: GMSCoordinateBounds = GMSCoordinateBounds().includingPath(path)
        let cameraUpdate: GMSCameraUpdate = GMSCameraUpdate.fitBounds(bouds, withPadding: 10)
        self.animateWithCameraUpdate(cameraUpdate)
    }
}
