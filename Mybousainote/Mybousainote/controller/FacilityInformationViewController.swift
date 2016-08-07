//
//  FacilityInformationViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/06.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class FacilityInformationViewController: UIViewController, DisasterInformationManagerDelegate, DirectionAPIManagerDelegate {
    
    @IBOutlet weak var mapView: FacilityMapView!
    
    @IBOutlet weak var testText: UITextView!
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var DIManager: DisasterInformationManager!
    var directionAPIManager: DirectionAPIManager!
    
    //ストリートビュー
    @IBOutlet weak var streetView: StreetView!
    
    
    //ルート格納用配列
    var routePoints: NSMutableArray!
    
    //アナリティクスのトラッカー
    let tracker = GAI.sharedInstance().defaultTracker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routePoints = NSMutableArray()

        //地図のカメラをセット
        mapView.setCameraLocation(appDelegate.global.centerLat, lng: appDelegate.global.centerLng)
        
        
        //デリゲート設定
        DIManager = DisasterInformationManager.init()
        DIManager.delegate = self
        
        //経路検索API管理クラス
        directionAPIManager = DirectionAPIManager.init()
        directionAPIManager.delegate = self
        
        //避難施設のIDを取得
        let id = appDelegate.global.selectedFacilityId as! Int
        
        //IDから情報を取得
        DIManager.getFacilityDataFromId(id)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        trackingScreen()
    }
    
    
    //スクリーンをトラッキング
    func trackingScreen() {
        tracker.set(kGAIScreenName, value: "避難施設詳細")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    //避難施設情報を取得したときに呼ばれる
    func didGetFacilityDataFromId(facility: AnyObject) {
        print(facility)
        
        let lat = Double(facility["lat"] as! String)
        let lng = Double(facility["lng"] as! String)
        
        //ストリートビューをセット
        streetView.setCameraPosition(lat!, lng: lng!)
        
        //経路を取得
        getRouteTofacility(lat!, lng: lng!)
        
        //各情報の抜き出し
        let name = facility["name"] as! String
        let address = facility["address"] as! String
        let facilityType = facility["facilityType"] as! String
        let seatingCapacity = facility["seatingCapacity"] as! String
        let facilityScale = facility["facilityScale"] as! String
        
        testText.text = name+"\n"+address+"\n"+facilityType+"\n"+seatingCapacity+"\n"+facilityScale
        print(name+"\n"+address+"\n"+facilityType+"\n"+seatingCapacity+"\n"+facilityScale)
    }
    
    //経路を取得する
    func getRouteTofacility(lat: Double, lng: Double) {
        //中心点の緯度経度を取得
        let originLat = appDelegate.global.centerLat
        let originLng = appDelegate.global.centerLng
        
        directionAPIManager.getRoutesData(originLat, originLng: originLng, destinationLat: lat, destinationLng: lng)
    }
    
    //経路の取得が成功したときに呼ばれる
    func didGetRoutes(routes: AnyObject) {

        //軌跡の各地点の緯度経度を格納
        let legs = routes[0]["legs"]!
        let startLocation = legs![0]["start_location"]!
        
        routePoints.addObject(startLocation!)
        
        let steps = legs![0]["steps"]! as! [AnyObject]
        for step in steps {
            let endLocation = step["end_location"]!
            routePoints.addObject(endLocation!)
        }
        
        //軌跡を描画する
        mapView.setPolyline(routePoints as [AnyObject])
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func touchedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
