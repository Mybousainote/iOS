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
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var DIManager: DisasterInformationManager!
    var directionAPIManager: DirectionAPIManager!
    
    //ストリートビュー
    @IBOutlet weak var streetView: StreetView!
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet weak var addressHead: UILabel!
    @IBOutlet weak var typeHead: UILabel!
    @IBOutlet weak var capacityHead: UILabel!
    
    @IBOutlet weak var addressValue: UILabel!
    @IBOutlet weak var typeValue: UILabel!
    @IBOutlet weak var capacityValue: UILabel!
    
    //ルート格納用配列
    var routePoints: NSMutableArray!
    
    //アナリティクスのトラッカー
    let tracker = GAI.sharedInstance().defaultTracker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routePoints = NSMutableArray()

        //地図のカメラをセット
        mapView.setCameraLocation(appDelegate.global.centerLat, lng: appDelegate.global.centerLng)
        //地図の枠
        mapView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).CGColor
        mapView.layer.borderWidth = 2.0
        mapView.layer.cornerRadius = 2.0
        
        
        //デリゲート設定
        DIManager = DisasterInformationManager.init()
        DIManager.delegate = self
        
        //経路検索API管理クラス
        directionAPIManager = DirectionAPIManager.init()
        directionAPIManager.delegate = self
        
        //避難施設のIDを取得
        let id = appDelegate.global.selectedFacilityId as Int
        
        //IDから情報を取得
        DIManager.getFacilityDataFromId(id)
    }
    
    override func viewWillAppear(animated: Bool) {
        trackingScreen()
    }
    
    override func viewDidAppear(animated: Bool) {
        stylingFont()
    }
    
    func stylingFont() {
        navigationTitle.font = UIFont.boldSystemFontOfSize(18)
        
        stylingTableText(facilityName, size: 15)
        
        stylingTableText(addressHead, size: 12)
        stylingTableText(typeHead, size: 12)
        stylingTableText(capacityHead, size: 12)
        
        stylingTableText(addressValue, size: 12)
        stylingTableText(typeValue, size: 12)
        stylingTableText(capacityValue, size: 12)
    }
    
    func stylingTableText(label: UILabel, size: CGFloat) {
        label.font = UIFont.boldSystemFontOfSize(size)
        label.numberOfLines = 0
        label.sizeToFit()
    }
    
    
    //スクリーンをトラッキング
    func trackingScreen() {
        tracker.set(kGAIScreenName, value: "避難施設詳細")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    //避難施設情報を取得したときに呼ばれる
    func didGetFacilityDataFromId(facility: AnyObject) {
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
        var seatingCapacity = facility["seatingCapacity"] as! String
        if seatingCapacity == "-1" {
            seatingCapacity = "不明"
        }
        else {
            seatingCapacity += "人"
        }
//        let facilityScale = facility["facilityScale"] as! String
        
        
        
        //ラベルをセットする
        navigationTitle.text = name
        navigationTitle.adjustsFontSizeToFitWidth = true
        
        facilityName.text = name
        addressValue.text = address
        typeValue.text = facilityType
        capacityValue.text = seatingCapacity
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "sizeToFit", userInfo: nil, repeats: false)
    }
    
    func sizeToFit() {
        facilityName.numberOfLines = 0
        facilityName.sizeToFit()
        addressValue.numberOfLines = 0
        addressValue.sizeToFit()
        typeValue.numberOfLines = 0
        typeValue.sizeToFit()
        capacityValue.numberOfLines = 0
        capacityValue.sizeToFit()
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
