//
//  StreetView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/06.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class StreetView: GMSPanoramaView, GMSPanoramaViewDelegate {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("ストリートビューの初期化")
        //デリゲートの設定
        self.delegate = self
    }
    
    func setCameraPosition(lat: Double, lng: Double) {
        self.moveNearCoordinate(CLLocationCoordinate2DMake(lat, lng), radius: 300)
    }
}
