//
//  MapView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/03.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: GMSMapView, GMSMapViewDelegate {
    
    //    let boundWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
    //    let boundHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeMap(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        print("MapViewの初期化")
        
        //カメラの設定
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 18)
        self.camera = camera
        
        //デリゲートの設定
        self.delegate = self
        
        //現在地の表示の設定
        self.myLocationEnabled = true
    }
}
