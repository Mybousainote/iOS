//
//  DisasterViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class DisasterViewController: UIViewController,DisasterInformationManagerDelegate, MapViewDelegate, FloodsViewDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //StoryBoard
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var informationView: UIView!
    var earthquakeView: EarthquakeView!
    var floodsView: FloodsView!
    var facilitiesView: FacilitiesView!
    
    var currentInformationView: String = "facilities"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲートの設定
        appDelegate.DIManager.delegate = self
        
        //トップ画面で選択した地点の情報を取得
        let livingAreaObject = appDelegate.global.selectedAreaObject as AnyObject
        
        //ヘッダーの地名をセット
        cityNameLabel.text = livingAreaObject["cityName"] as? String
        
        //地図のカメラをセット
        mapView.setCameraLocation(livingAreaObject["lat"] as! Double, lng: livingAreaObject["lng"] as! Double)
        mapView.mapViewDelegate = self
        
        
        //まず避難施設情報をセット
        createFacilitesView()
        getFacilitiesData()
    }
    
    //地図の移動が終わったときに呼ばれる
    func didFinishChangeCameraPosition() {
        print("ドラッグ終了")
        
        //ズームレベルが一定以上の場合避難施設情報を読み込む
        if mapView.camera.zoom > Config().thresholdShowMarkerZoomLevel {
            getFacilitiesData() //避難施設情報の取得
        }else {
            mapView.removeAllMarkers() //マーカーを削除
        }
        
        switch currentInformationView {
        case "earthquake":
            getEarthquakeData() //地震情報の取得
            break
        case "floods":
            getWaterDepth() //浸水深の取得
            break
        default:
            break
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
        appDelegate.global.showLoadingView(self.view, messege: "タイルを読み込み中...") //ローディング画面を表示
        appDelegate.DIManager.getFloodsData(mapView.centerLat, lng: mapView.centerLng, rectSize: Config().getFloodsRectSize)
    }
    
    //浸水情報を取得したときに呼ばれる
    func didGetFloodsData(floods: [AnyObject]) {
        
        //ポリゴンを一旦全削除
        mapView.removeAllFloodPolygons()
        
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
            
            mapView.setFloodsPolygon(polygonPoints as NSArray, polygonColor: polygonColor)
        }
        print("ポリゴン作成完了！")
        appDelegate.global.removeLoadingView() //ローディング画面を削除
    }
    
    //中心点の浸水深を取得
    func getWaterDepth() {
        appDelegate.DIManager.getWaterDepth(mapView.centerLat, lng: mapView.centerLng)
    }
    
    //中心点の浸水深を取得したときに呼ばれる
    func didGetWaterDepth(waterDepth: String) {
        //ラベルをセット
        floodsView.setInformation(Config().warterDepthValues[waterDepth] as! String)
    }
    
    
    
    
    
    //MARK: - ボタンタッチイベント
    
    //避難施設ボタン
    @IBAction func touchedFacilitiesButton(sender: AnyObject) {
        currentInformationView = "facilities"
        
        createFacilitesView()
        informationView.bringSubviewToFront(facilitiesView)
    }
    
    func createFacilitesView() {
        if facilitiesView == nil {
            facilitiesView = FacilitiesView.instance()
            facilitiesView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            informationView.addSubview(facilitiesView)
        }
    }
    
    //地震ボタン
    @IBAction func touchedEarthquakeButton(sender: AnyObject) {
        print("地震ボタンがタップされた")
        currentInformationView = "earthquake"
        
        if earthquakeView == nil {
            earthquakeView = EarthquakeView.instance()
            earthquakeView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            informationView.addSubview(earthquakeView)
        }
        informationView.bringSubviewToFront(earthquakeView)
        
        //震度情報を読み込む
        getEarthquakeData()
    }
    
    //浸水ボタン
    @IBAction func touchedFloodsButton(sender: AnyObject) {
        print("浸水ボタンがタップされた")
        currentInformationView = "floods"
        
        if floodsView == nil {
            floodsView = FloodsView.instance()
            floodsView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            //デリゲート設定
            floodsView.delegate = self
            informationView.addSubview(floodsView)
            
            //浸水情報を読み込む
            getFloodsData()
        }
        informationView.bringSubviewToFront(floodsView)
        
        //中心点の浸水深を読み込む
        getWaterDepth()
    }
    
    //浸水タイル再読み込みボタン
    func didTouchedReloadButton() {
        getFloodsData()
    }
    
    
    
    
    //土砂災害ボタン
    @IBAction func touchedSedimentButton(sender: AnyObject) {
        appDelegate.global.removeLoadingView()
        
        mapView.removeAllFloodPolygons()
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
