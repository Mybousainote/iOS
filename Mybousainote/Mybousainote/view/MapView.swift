//
//  MapView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/03.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapViewDelegate {
    func didFinishChangeCameraPosition()
}

class MapView: GMSMapView, GMSMapViewDelegate {
    
    //デリゲートをオーバーライド（ただし結局使わなかった）
//    var myDelegate: MapViewDelegate? {
//        get { return self.delegate as? MapViewDelegate }
//        set { self.delegate = newValue }
//    }
    
    var markers: NSMutableArray!
    
    var mapViewDelegate: MapViewDelegate!
    
    var allowLoadFacilities: Bool = false
    
    //中心点の緯度経度
    var centerLat: Double!
    var centerLng: Double!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("地図ビューの初期化")
        //デリゲートの設定
        self.delegate = self
        
        //現在地の表示の設定
        self.myLocationEnabled = true
        
        markers = NSMutableArray()
    }
    
    func setCameraLocation(lat: Double, lng: Double) {
        let camera = GMSCameraPosition.cameraWithLatitude(lat as CLLocationDegrees, longitude: lng as CLLocationDegrees, zoom: 15)
        self.camera = camera
        
        centerLat = lat
        centerLng = lng
    }
    
    var timer: NSTimer?
    
    //地図を動かしたときに呼ばれる
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        
        //地図の読み込み時に呼ばれないようにする
        if allowLoadFacilities == true {
            centerLat = position.target.latitude
            centerLng = position.target.longitude
            
            if timer != nil {
                timer!.invalidate()
            }
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(MapView.callDidFinishChangeCameraPosition), userInfo: nil, repeats: false)
        }
    }
    
    //デリゲートメソッドを呼ぶ
    func callDidFinishChangeCameraPosition() {
        mapViewDelegate.didFinishChangeCameraPosition()
    }
    
    //避難施設のマーカーを立てる
    func setFacilitiesPins(lat: Double, lng: Double, name: String, num: Int) {
        
        let position = CLLocationCoordinate2DMake(lat, lng)
        let marker = GMSMarker(position: position)
        marker.title = name
        
        let pinName = "pin_\(num).png"
        let img: UIImage! = UIImage(named: pinName)
        marker.icon = img
        marker.map = self
        
        markers.addObject(marker)
    }
    
    //マーカーがタップされたときに呼ばれる
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        print("マーカーがタップされた")
        allowLoadFacilities = false
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(MapView.setAllowLoadFacilities), userInfo: nil, repeats: false)
        
        return false
    }
    
    //マーカーがタップされた数秒後、地図移動後の避難施設読み込みを許可する
    func setAllowLoadFacilities() {
        print("許可！")
        allowLoadFacilities = true
    }
    
    //マーカーのウィンドウがタップされたときに呼ばれる
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        print("マーカーウィンドウがタップされた")
    }
    
    //マーカーをリセットする
    func removeAllMarkers() {
        for marker in markers {
            (marker as! GMSMarker).map  = nil
        }
        markers = NSMutableArray()
    }
    

}
