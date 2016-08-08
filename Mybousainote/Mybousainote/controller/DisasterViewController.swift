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
    
    //防災情報取得の管理クラス
    var DIManager: DisasterInformationManager!
    
    //StoryBoard
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var informationView: UIView!
    var earthquakeView: EarthquakeView!
    var floodsView: FloodsView!
    var facilitiesView: FacilitiesView!
    var sedimentsView: SedimentsView!
    
    var currentInformationView: String = "facilities"
    
    //最後にポリゴンを取得した地点の緯度経度
    var latDidLoadFloodPolygon: Double!
    var lngDidLoadFloodPolygon: Double!
    var latDidLoadSedimentPolygon: Double!
    var lngDidLoadSedimentPolygon: Double!
    
    //アナリティクスのトラッカー
    let tracker = GAI.sharedInstance().defaultTracker
    
    //タブアイコン
    @IBOutlet weak var facilityIcon: UIImageView!
    @IBOutlet weak var earthquakeIcon: UIImageView!
    @IBOutlet weak var sedimentIcon: UIImageView!
    @IBOutlet weak var floodIcon: UIImageView!
    
    //タブボタンの背景
    @IBOutlet weak var facilityButtonBg: UIView!
    @IBOutlet weak var earthquakeButtonBg: UIView!
    @IBOutlet weak var sedimentButtonBg: UIView!
    @IBOutlet weak var floodButtonBg: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲートの設定
        DIManager = DisasterInformationManager.init()
        DIManager.delegate = self
        
        //トップ画面で選択した地点の情報を取得
        let livingAreaObject = appDelegate.global.selectedAreaObject as AnyObject
        
        //ヘッダーの地名をセット
        cityNameLabel.text = livingAreaObject["cityName"] as? String
        cityNameLabel.font = UIFont.boldSystemFontOfSize(18)
        
        //地図のカメラをセット
        mapView.setCameraLocation(livingAreaObject["lat"] as! Double, lng: livingAreaObject["lng"] as! Double)
        mapView.mapViewDelegate = self
        
        
        //まず避難施設情報をセット
        createFacilitesView()
        getFacilitiesData()
        stylingTabButtonAlpha(facilityIcon)
    }
    
    //ステータスバーを白くする
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        trackingScreen()
    }
    
    //スクリーンをトラッキング
    func trackingScreen() {
        tracker.set(kGAIScreenName, value: "防災情報")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    
    
    
    //地図の移動が終わったときに呼ばれる
    func didFinishChangeCameraPosition() {
        print("ドラッグ終了")
        //ズームレベルが一定以上の場合諸々読み込む
        if mapView.camera.zoom > Config().thresholdShowMarkerZoomLevel {
            getFacilitiesData() //避難施設情報の取得
            
            if currentInformationView == "floods" {
                setNewFloodPolygons()
            }
            else if currentInformationView == "sediments" {
                setNewSedimentPolygons()
            }
        }else {
            mapView.removeAllMarkers() //マーカーを削除
            //ポリゴンを非表示にする
            mapView.hiddenAllFloodPolygons()
            mapView.hiddenAllSedimentsPolygons()
        }
        
        //ズームレベル関係なく読み込むもの
        switch currentInformationView {
        case "earthquake":
            getEarthquakeData() //地震情報の取得
            break
        case "floods":
            getWaterDepth() //浸水深の取得
            break
        case "sediments":
            getSedimentType() //土砂災害の種別の取得
            break
        default:
            break
        }
    }
    
    //浸水ポリゴン
    func setNewFloodPolygons() {
        if latDidLoadFloodPolygon != nil {
            //最後に取得した地点からの距離を取得
            let distance = calcurateDistance(mapView.centerLat, y1: mapView.centerLng, x2: latDidLoadFloodPolygon, y2: lngDidLoadFloodPolygon)
            
            if distance > Config().rectSizeForGetPolygon/2 {
                getFloodsData() //一定距離以上離れてる場合は新たにデータを読み込む
            } else {
                mapView.showAllFloodPolygons() //特に離れてない場合は既にあるデータを表示する
            }
        }
    }
    
    //土砂ポリゴン
    func setNewSedimentPolygons() {
        if latDidLoadSedimentPolygon != nil {
            //最後に取得した地点からの距離を取得
            let distance = calcurateDistance(mapView.centerLat, y1: mapView.centerLng, x2: latDidLoadSedimentPolygon, y2: lngDidLoadSedimentPolygon)
            
            if distance > Config().rectSizeForGetPolygon/2 {
                getSedimentsData() //一定距離以上離れてる場合は新たにデータを読み込む
            } else {
                mapView.showAllSedimentsPolygons() //特に離れてない場合は既にあるデータを表示する
            }
        }
    }
    
    //二点間の距離を計算
    func calcurateDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double{
        let a = pow(x1-x2, 2)
        let b = pow(y1-y2, 2)
        let distance = sqrt(a+b)
        return distance
    }
    
    
    
    
    
    //MARK: - 避難施設

    //避難施設情報を取得
    func getFacilitiesData() {
        DIManager.getFacilitiesData(mapView.centerLat, lng: mapView.centerLng, length: Config().BoundForGetFacilities)
        
        let builder = GAIDictionaryBuilder.createEventWithCategory("防災情報の取得", action: "避難施設", label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    //避難施設情報を取得したときに呼ばれる
    func didGetFacilitiesData(facilities: [AnyObject]) {
        //地図をドラッグする度に新しいデータを読み込むのを許可
        mapView.allowLoadNewData = true
        
        //マーカーを一旦全削除
        mapView.removeAllMarkers()
        
        //4つのボタン作成用
        var buttonInformations = NSMutableArray()
        
        var count = 0
        for facility in facilities {
            count += 1
            
            let id = facility["id"] as! String
            let name = facility["name"] as! String
            let lat = facility["lat"] as! String
            let lng = facility["lng"] as! String
            
            //一番近い4つはマーカーを変える
            var num = count
            if num > 4 {
                num = 0
            }
            //マーカーを立てる
            mapView.setFacilitiesMarkers(Double(lat)!, lng: Double(lng)!, name: name, num: num, id: id)
            
            
            if count <= 4 {
                let buttonInformation = [
                    "num": "\(count)",
                    "id": id,
                    "name": name
                ]
                buttonInformations.addObject(buttonInformation)
            }
        }
        //上位４つのボタンを作成する
        facilitiesView.setFacilitiesListButton(buttonInformations)
    }
    
    //避難施設のボタンが押されたとき呼ばれる
    func touchedFacilitiesListButton(button: UIButton) {
        let builder = GAIDictionaryBuilder.createEventWithCategory("避難施設詳細へ遷移", action: "リストから選択", label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        //選択された避難施設のIDをViewController共有用に保存し、画面遷移
        appDelegate.global.selectedFacilityId = button.tag
        
        //同じく中心点の緯度経度を保存
        appDelegate.global.centerLat = mapView.centerLat
        appDelegate.global.centerLng = mapView.centerLng
        
        transitionToFacilityInformationView()
    }
    
    //マーカーウィンドウがタッチされたときに呼ばれる
    func didTouchMakerWindow(id: String) {
        let builder = GAIDictionaryBuilder.createEventWithCategory("避難施設詳細へ遷移", action: "ピンから選択", label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        //選択された避難施設のIDをViewController共有用に保存し、画面遷移
        appDelegate.global.selectedFacilityId = Int(id)
        
        //同じく中心点の緯度経度を保存
        appDelegate.global.centerLat = mapView.centerLat
        appDelegate.global.centerLng = mapView.centerLng
        
        transitionToFacilityInformationView()
    }
    

    
    
    
    
    
    
    //MARK: - 地震
    
    //地震情報を取得
    func getEarthquakeData() {
        DIManager.getEarthquakeData(mapView.centerLat, lng: mapView.centerLng)
        
        let builder = GAIDictionaryBuilder.createEventWithCategory("防災情報の取得", action: "地震危険度", label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    //地震情報を取得したときに呼ばれる
    func didGetEarthquakeData(earthquake: AnyObject) {
        let features = earthquake["features"] as! [AnyObject]
        let properties = features[0]["properties"]
        let T30_I45_PS = Double(properties!!["T30_I45_PS"] as! String) //30年間で震度5弱以上となる確率
        let T30_I50_PS = Double(properties!!["T30_I50_PS"] as! String) //30年間で震度5強以上となる確率
        let T30_I55_PS = Double(properties!!["T30_I55_PS"] as! String) //30年間で震度6弱以上となる確率
        let T30_I60_PS = Double(properties!!["T30_I60_PS"] as! String)//30年間で震度6強以上となる確率
        
        //%変換＆小数点第二位以下切り捨て
        let I45 = "\(floor(T30_I45_PS! * 1000) / 10)"
        let I50 = "\(floor(T30_I50_PS! * 1000) / 10)"
        let I55 = "\(floor(T30_I55_PS! * 1000) / 10)"
        let I60 = "\(floor(T30_I60_PS! * 1000) / 10)"
        
        earthquakeView.setInformation(I45, I50: I50, I55: I55, I60: I60)
    }
    
    
    
    
    //MARK: - 浸水
    
    //浸水情報を取得
    func getFloodsData() {
        appDelegate.global.showLoadingView(self.view, messege: "読み込み中...") //ローディング画面を表示
        DIManager.getFloodsData(mapView.centerLat, lng: mapView.centerLng, rectSize: Config().rectSizeForGetPolygon)
        
        //このときの緯度経度を保存しておく
        latDidLoadFloodPolygon = mapView.centerLat
        lngDidLoadFloodPolygon = mapView.centerLng
        
        let builder = GAIDictionaryBuilder.createEventWithCategory("防災情報の取得", action: "洪水浸水", label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
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
//            print(polygonPoints)
            
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
        DIManager.getWaterDepth(mapView.centerLat, lng: mapView.centerLng)
    }
    
    //中心点の浸水深を取得したときに呼ばれる
    func didGetWaterDepth(waterDepth: String) {
        //ラベルをセット
        floodsView.setInformation(Config().warterDepthValues[waterDepth] as! String)
    }
    
    
    
    
    
    
    
    
    
    //MARK: - 土砂情報
    
    //土砂情報を取得
    func getSedimentsData() {
        appDelegate.global.showLoadingView(self.view, messege: "読み込み中...") //ローディング画面を表示
        DIManager.getSedimentsData(mapView.centerLat, lng: mapView.centerLng, rectSize: Config().rectSizeForGetPolygon)
        
        //このときの緯度経度を保存しておく
        latDidLoadSedimentPolygon = mapView.centerLat
        lngDidLoadSedimentPolygon = mapView.centerLng
        
        let builder = GAIDictionaryBuilder.createEventWithCategory("防災情報の取得", action: "土砂災害", label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    //土砂情報を取得したときに呼ばれる
    func didGetSedimentsData(sediments: [AnyObject]) {
        
        //ポリゴンを一旦全削除
        mapView.removeAllSedimentPolygons()
        
        for sediment in sediments {
            
            //Polygon生成用にStringデータを[[緯度, 経度]]に整形
            var posList = sediment["posList"] as! String
            let startIndex = posList.startIndex.advancedBy(9)
            let endIndex = posList.endIndex.advancedBy(-3)
            posList = posList.substringWithRange(startIndex...endIndex)
            
            let latLngs = posList.componentsSeparatedByString(",")
            
            let polygonPoints = NSMutableArray()
            for latLng in latLngs {
                let latAndLng = latLng.componentsSeparatedByString(" ")
                polygonPoints.addObject(latAndLng)
            }
//            print(polygonPoints)
            
            
            //現象の種類
            let type = sediment["type"] as! String
            let vigilanceDivision = sediment["vigilanceDivision"] as! String
            
            let typeName = Config().typeName[type]
            let vigilanceDivisionName = Config().vigilanceDivisionName[vigilanceDivision]
            
            let polygonColor = Config().sedimentAreaColors[typeName!]!![vigilanceDivisionName!] as! UIColor
            
            mapView.setSedimentsPolygon(polygonPoints as NSArray, polygonColor: polygonColor)
        }
        print("ポリゴン作成完了！")
        appDelegate.global.removeLoadingView() //ローディング画面を削除
    }
    
    //中心点の土砂災害の種別を取得
    func getSedimentType() {
        DIManager.getSedimentType(mapView.centerLat, lng: mapView.centerLng)
    }
    
    //中心点の土砂災害の種別を取得したときに呼ばれる
    func didGetSedimentType(sedimentType: String) {
        sedimentsView.setInformation(sedimentType)
    }
    
    
    
    
    

    
    
    //MARK: - ボタンタッチイベント
    
    //避難施設ボタン
    @IBAction func touchedFacilitiesButton(sender: AnyObject) {
        currentInformationView = "facilities"
        trackingIconToucheEvent("避難施設情報")
        
        createFacilitesView()
        informationView.bringSubviewToFront(facilitiesView)
        
        //ポリゴンを非表示にする
        mapView.hiddenAllFloodPolygons()
        mapView.hiddenAllSedimentsPolygons()
        
        //アイコンの透明度を変える
        stylingTabButtonAlpha(facilityIcon)
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
        trackingIconToucheEvent("地震危険度")
        currentInformationView = "earthquake"
        
        if earthquakeView == nil {
            earthquakeView = EarthquakeView.instance()
            earthquakeView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            earthquakeView.stylingBoldFont()
            informationView.addSubview(earthquakeView)
        }
        informationView.bringSubviewToFront(earthquakeView)
        
        //震度情報を読み込む
        getEarthquakeData()
        
        //ポリゴンを非表示にする
        mapView.hiddenAllFloodPolygons()
        mapView.hiddenAllSedimentsPolygons()
        
        //アイコンの透明度を変える
        stylingTabButtonAlpha(earthquakeIcon)
    }
    
    //浸水ボタン
    @IBAction func touchedFloodsButton(sender: AnyObject) {
        print("浸水ボタンがタップされた")
        trackingIconToucheEvent("洪水浸水")
        currentInformationView = "floods"
        
        if floodsView == nil {
            floodsView = FloodsView.instance()
            floodsView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            floodsView.stylingBoldFont()
            //デリゲート設定
            floodsView.delegate = self
            informationView.addSubview(floodsView)
            
            //浸水情報を読み込む
            getFloodsData()
        }else {
            setNewFloodPolygons()
        }
        informationView.bringSubviewToFront(floodsView)
        
        //中心点の浸水深を読み込む
        getWaterDepth()
        
        //土砂ポリゴンを非表示にする
        mapView.hiddenAllSedimentsPolygons()
        
        //アイコンの透明度を変える
        stylingTabButtonAlpha(floodIcon)
    }
    
    //浸水タイル再読み込みボタン
    func didTouchedReloadButton() {
//        getFloodsData()
    }
    
    
    //土砂災害ボタン
    @IBAction func touchedSedimentButton(sender: AnyObject) {
        print("土砂ボタンがタップされた")
        trackingIconToucheEvent("土砂災害")
        currentInformationView = "sediments"
        
        if sedimentsView == nil {
            sedimentsView = SedimentsView.instance()
            sedimentsView.frame = CGRectMake(0, 0, informationView.frame.width, informationView.frame.height)
            sedimentsView.stylingBoldFont()
            informationView.addSubview(sedimentsView)
            
            //土砂情報を読み込む
            getSedimentsData()
        }else {
            setNewSedimentPolygons()
        }
        informationView.bringSubviewToFront(sedimentsView)
        
        //浸水ポリゴンを非表示にする
        mapView.hiddenAllFloodPolygons()
        
        //アイコンの透明度を変える
        stylingTabButtonAlpha(sedimentIcon)
    }
    
    //防災画面の切り替えをトラッキング
    func trackingIconToucheEvent(actionName: String) {
        let builder = GAIDictionaryBuilder.createEventWithCategory("防災画面切り替え", action: actionName, label: "", value: nil)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    //タブの背景をリセット
//    func resetTabBackground() {
//        facilityButtonBg.backgroundColor = nil
//        earthquakeButtonBg.backgroundColor = nil
//        sedimentButtonBg.backgroundColor = nil
//        floodButtonBg.backgroundColor = nil
//    }
    
    func stylingTabButtonAlpha(icon: UIImageView) {
        facilityIcon.alpha = 0.7
        earthquakeIcon.alpha = 0.7
        sedimentIcon.alpha = 0.7
        floodIcon.alpha = 0.7
        
        icon.alpha = 1.0
    }
    
    
    //画面遷移
    func transitionToFacilityInformationView() {
        print("避難施設詳細画面へ遷移")
        let storyboard = UIStoryboard(name: "FacilityInformation", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
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
