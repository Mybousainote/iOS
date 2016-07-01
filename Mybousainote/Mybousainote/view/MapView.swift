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
    
    var facilityMarkers: NSMutableArray!
    var floodPolygons: NSMutableArray!
    
    var mapViewDelegate: MapViewDelegate!
    
    var allowLoadNewData: Bool = false
    
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
        
        //現在地ボタンの表示の設定
        self.settings.myLocationButton = true
        
        facilityMarkers = NSMutableArray()
        floodPolygons = NSMutableArray()
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
        
        centerLat = position.target.latitude
        centerLng = position.target.longitude
        
        
        //MapViewインスタンスの作成時/マーカータップ時/ズームレベルが低い時に呼ばれないようにする
//        if allowLoadNewData == true && mapView.camera.zoom > 12 {
//            if timer != nil {
//                timer!.invalidate()
//            }
//            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(MapView.callDidFinishChangeCameraPosition), userInfo: nil, repeats: false)
//        }
//        //ズーム度が低いときは表示中の情報をリセットする
//        else if allowLoadNewData == true && mapView.camera.zoom < 12 {
//            if timer != nil {
//                timer!.invalidate()
//            }
//            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(MapView.removeAllContents), userInfo: nil, repeats: false)
//        }
        
        //MapViewインスタンスの作成時/マーカータップ時に呼ばれないようにする
        if allowLoadNewData == true {
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
    
    //表示中の情報をリセットする
//    func removeAllContents() {
//        print("地図上の情報をリセット")
//        removeAllMarkers()
//    }
    
    
    
    //MARK: - 避難施設
    
    //避難施設のマーカーを立てる
    func setFacilitiesPins(lat: Double, lng: Double, name: String, num: Int) {
//        print("避難施設のマーカーを立てる")
        
        let position = CLLocationCoordinate2DMake(lat, lng)
        let marker = GMSMarker(position: position)
        marker.title = name
        
        let pinName = "pin_\(num).png"
        let img: UIImage! = UIImage(named: pinName)
        marker.icon = img
        marker.map = self
        
        facilityMarkers.addObject(marker)
    }
    
    //マーカーがタップされたときに呼ばれる
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        print("マーカーがタップされた")
        allowLoadNewData = false
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(MapView.setAllowLoadFacilities), userInfo: nil, repeats: false)
        
        return false
    }
    
    //マーカーがタップされた数秒後、地図移動後のデータ読み込みを許可する
    func setAllowLoadFacilities() {
        print("データの更新を許可")
        allowLoadNewData = true
    }
    
    //マーカーのウィンドウがタップされたときに呼ばれる
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        print("マーカーウィンドウがタップされた")
    }
    
    //マーカーをリセットする
    func removeAllMarkers() {
        for marker in facilityMarkers {
            (marker as! GMSMarker).map  = nil
        }
        facilityMarkers = NSMutableArray()
    }
    
    
    
    
    
    
    //MARK: - 浸水
    
    func setFloodsPolygon(polygonPoints: NSArray, polygonColor: UIColor) {
        print("浸水深のポリゴンを作成")
        
        let path = GMSMutablePath()
        
        for polygonPoint in polygonPoints {
            let lat = Double((polygonPoint as! NSArray)[0] as! String)
            let lng = Double((polygonPoint as! NSArray)[1] as! String)
            
            path.addCoordinate(CLLocationCoordinate2DMake(lat!, lng!))
        }
        
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = polygonColor
//        polygon.strokeColor = UIColor.blackColor()
//        polygon.strokeWidth = 2
        polygon.map = self
        
        floodPolygons.addObject(polygon)
    }
 
    //ポリゴンをリセットする
    func removeAllFloodPolygons() {
        for polygons in floodPolygons {
            (polygons as! GMSPolygon).map  = nil
        }
        floodPolygons = NSMutableArray()
    }
    
}
