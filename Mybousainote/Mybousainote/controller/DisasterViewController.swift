//
//  DisasterViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class DisasterViewController: UIViewController,DisasterInformationManagerDelegate, MapViewDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //StoryBoard
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var informationView: UIView!
    var earthquakeView: EarthquakeView!
    var floodsView: FloodsView!
    
    var currentInformationView: String = "facilites"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.DIManager.delegate = self
        
        //トップ画面で選択した地点の情報を取得
        let livingAreaObject = appDelegate.global.selectedAreaObject as AnyObject
        
        //ヘッダーの地名をセット
        cityNameLabel.text = livingAreaObject["cityName"] as? String
        
        //地図のカメラをセット
        mapView.setCameraLocation(livingAreaObject["lat"] as! Double, lng: livingAreaObject["lng"] as! Double)
        mapView.mapViewDelegate = self
        
        getFacilitiesData()
    }
    
    //地図の移動が終わったときに呼ばれる
    func didFinishChangeCameraPosition() {
        print("ドラッグ終了")
        
        getFacilitiesData() //避難施設情報の取得
        
        if currentInformationView == "earthquake" {
            getEarthquakeData() //地震情報の取得
        }
    }
    
    //MARK: - 避難施設

    //避難施設情報を取得
    func getFacilitiesData() {
        appDelegate.DIManager.getFacilitiesData(mapView.centerLat, lng: mapView.centerLng, length: Config().getFacilitiesBound)
    }
    
    //避難施設情報を取得したときに呼ばれる
    func didGetFacilitiesData(facilities: [AnyObject]) {
        //地図をドラッグする度に新しいデータを読み込むのを許可
        mapView.allowLoadNewData = true
        
        //マーカーを一旦全削除
        mapView.removeAllMarkers()
        
        var count = 0
        for facility in facilities {
            count += 1
            
            let name = facility["name"] as! String
            let lat = facility["lat"] as! String
            let lng = facility["lng"] as! String
            
            var num = count
            if num > 4 {
                num = 0
            }
            mapView.setFacilitiesPins(Double(lat)!, lng: Double(lng)!, name: name, num: num)
        }
//        mapView.setFacilitiesPins(mapView.centerLat, lng: mapView.centerLng, name:  "テスト", num: 0)
    }
    
    
    
    
    
    
    
    //MARK: - 地震
    
    //地震情報を取得
    func getEarthquakeData() {
        appDelegate.DIManager.getEarthquakeData(mapView.centerLat, lng: mapView.centerLng)
    }
    
    //地震情報を取得したときに呼ばれる
    func didGetEarthquakeData(earthquake: AnyObject) {
        let features = earthquake["features"] as! [AnyObject]
        let properties = features[0]["properties"]
        let T30_I45_PS = properties!!["T30_I45_PS"] as! String //30年間で震度5弱以上となる確率
        print(T30_I45_PS)
        earthquakeView.setInformation(T30_I45_PS)
    }
    
    
    
    
    //MARK: - 浸水
    
    //浸水情報を取得
    func getFloodsData() {
        appDelegate.DIManager.getFloodsData(0, lng: 0)
    }
    
    //浸水情報を取得したときに呼ばれる
    func didGetFloodsData(floods: [AnyObject]) {
        
        for flood in floods {
            
            //Polygon生成用にStringデータを[[緯度, 経度]]に整形
            var posList = flood["posList"] as! String
            let startIndex = posList.startIndex.advancedBy(9)
            let endIndex = posList.endIndex.advancedBy(-3)
            posList = posList.substringWithRange(startIndex...endIndex)
            
            let latLngs = posList.componentsSeparatedByString(",")

            let polygonPoints = NSMutableArray()
            for latLng in latLngs {
                let latAndLng = latLng.componentsSeparatedByString(" ")
                polygonPoints.addObject(latAndLng)
            }
            
            print(polygonPoints)
            
            //浸水深
            let waterDepth = flood["waterDepth"] as! String
            let polygonColor = Config().warterDepthColors[waterDepth] as! UIColor
            
            print(polygonColor)
            
            mapView.setFloodsPolygon(polygonPoints as NSArray, polygonColor: polygonColor)
        }
//        mapView.setFloodsPolygon()
    }
    
    
    
    
    
    //MARK: - アイコンタッチイベント
    
    @IBAction func touchedFacilitiesButton(sender: AnyObject) {
        currentInformationView = "facilities"
    }
    
    @IBAction func touchedEarthquakeButton(sender: AnyObject) {
        print("地震ボタンがタップされた")
        currentInformationView = "earthquake"
        
        if earthquakeView == nil {
            earthquakeView = EarthquakeView.instance()
            earthquakeView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            informationView.addSubview(earthquakeView)
        }
        informationView.bringSubviewToFront(earthquakeView)
        getEarthquakeData()
    }
    
    @IBAction func touchedFloodsButton(sender: AnyObject) {
        print("浸水ボタンがタップされた")
        currentInformationView = "floods"
        
        if floodsView == nil {
            floodsView = FloodsView.instance()
            floodsView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            informationView.addSubview(floodsView)
        }
        informationView.bringSubviewToFront(floodsView)
        getFloodsData()
    }
    
    
    @IBAction func touchedSedimentButton(sender: AnyObject) {
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
