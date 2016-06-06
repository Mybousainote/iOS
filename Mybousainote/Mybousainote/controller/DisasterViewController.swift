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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.DIManager.delegate = self
        
        //トップ画面で選択した地点の情報を取得
        let livingArea = appDelegate.global.selectedArea as AnyObject
        
        //ヘッダーの地名をセット
        cityNameLabel.text = livingArea["cityName"] as? String
        
        //地図のカメラをセット
        mapView.setCameraLocation(livingArea["lat"] as! Double, lng: livingArea["lng"] as! Double)
        mapView.mapViewDelegate = self
        
        getFacilitiesData()
    }

    //避難施設情報を取得
    func getFacilitiesData() {
        print(mapView)
        appDelegate.DIManager.getFacilitiesData(mapView.centerLat, lng: mapView.centerLng, length: Config().getFacilitiesBound)
    }
    
    //避難施設情報を取得したときに呼ばれる
    func didGetFacilitiesData(facilities: [AnyObject]) {
        mapView.isFirstLoad = false
        
        //ピンを一旦全削除
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
    
    //地図の移動が終わったときに呼ばれる
    func didFinishChangeCameraPosition() {
        print("ドラッグ終了")
        getFacilitiesData()
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
