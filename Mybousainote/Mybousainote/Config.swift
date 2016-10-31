//
//  Config.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit

public class Config {
    //Google API key
    let googleAPIKey: String = "AIzaSyB7lwbZsfTWQopgQ9p64n5edGnu9gqfBXA"
    
    //デバッグ用アラートを表示するか否か
    let isForDebug: Bool = false
    
    //位置情報履歴を保存する期間（日）
    let timeIntervalHoldData: Double = 30
    
    //アプリ起動時に位置情報を取得するインターバル（秒）
    let timeIntervalUpdatingLocation: NSTimeInterval = 60
    
    //避難施設を取得する中心点からの範囲（m）
    let BoundForGetFacilities: Int = 3000
    
    //ポリゴン情報を取得する正方形の一片の長さ（緯度経度数）
    let rectSizeForGetPolygon: Double = 0.1
    
    //避難施設マーカーを表示するズームレベルの閾値
    let thresholdShowMarkerZoomLevel: Float = 12
    
    //仮想ペルソナの生活圏を表示するか否か
    let isVirtualPersona: Bool = false
    
    //仮想ペルソナの生活圏
    let virtualLivingArea: [AnyObject] = [
        [
            "cityName": "鎌倉市大船", //自宅
            "subLocality": "大船",
            "lat": 35.317931,
            "lng": 139.499904
        ],
        [
            "cityName": "鎌倉市津西", //勤務地
            "subLocality": "津西",
            "lat": 35.353113,
            "lng": 139.538310
        ],
        [
            "cityName": "鎌倉市鎌倉山", //よく行くカフェ
            "subLocality": "鎌倉山",
            "lat": 35.318271,
            "lng": 139.514939
        ],
        [
            "cityName": "鎌倉市小町", //スポーツクラブ
            "subLocality": "小町",
            "lat": 35.318734,
            "lng": 139.552864
        ]
    ]
    
    //各浸水深の値
    let warterDepthValues: AnyObject = [
        "0": "0",
        
        "11": "0-0.5",
        "12": "0.5-1.0",
        "13": "1.0-2.0",
        "14": "2.0-5.0",
        "15": "5.0-",
        
        "21": "0-0.5",
        "22": "0.5-1.0",
        "23": "1.0-2.0",
        "24": "2.0-3.0",
        "25": "3.0-4.0",
        "26": "4.0-5.0",
        "27": "5.0-"
    ]
    
    //各浸水深のポリゴンの色
    let warterDepthColors: AnyObject = [
        "11": UIColor(red: 255/255, green: 230/255, blue: 0/255, alpha: 0.6), //0～0.5ｍ未満（5段階）
        "12": UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 0.6), //0.5～1.0ｍ未満（5段階）
        "13": UIColor(red: 239/255, green: 117/255, blue: 152/255, alpha: 0.6), //1.0～2.0ｍ未満（5段階）
        "14": UIColor(red: 255/255, green: 40/255, blue: 0/255, alpha: 0.6), //2.0～5.0ｍ未満（5段階）
        "15": UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 0.6), //5.0ｍ以上（5段階）
        
        "21": UIColor(red: 255/255, green: 230/255, blue: 0/255, alpha: 0.6), //0～0.5ｍ未満（7段階）
        "22": UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 0.6), //0.5～1.0ｍ未満（7段階）
        "23": UIColor(red: 239/255, green: 117/255, blue: 152/255, alpha: 0.6), //1.0～2.0ｍ未満（7段階）
        "24": UIColor(red: 255/255, green: 40/255, blue: 0/255, alpha: 0.6), //2.0～3.0ｍ未満（7段階）
        "25": UIColor(red: 255/255, green: 40/255, blue: 0/255, alpha: 0.6), //3.0～4.0ｍ未満（7段階）
        "26": UIColor(red: 255/255, green: 40/255, blue: 0/255, alpha: 0.6), //4.0～5.0ｍ未満（7段階）
        "27": UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 0.6) //5.0ｍ以上（7段階）
    ]
    
    //土砂災害の種類
    let typeName = [
        "1": "急傾斜地",
        "2": "土石流",
        "3": "地滑り"
    ]
    
    //土砂災害の区域区分
    let vigilanceDivisionName = [
        "1": "警戒区域",
        "2": "特別警戒区域",
        "3": "警戒区域",
        "4": "特別警戒区域"
    ]
    
    //土砂災害警戒区域のポリゴンの色
    let sedimentAreaColors: AnyObject = [
        "急傾斜地": [
            "警戒区域": UIColor(red: 255/255, green: 230/255, blue: 0/255, alpha: 0.6),
            "特別警戒区域": UIColor(red: 230/255, green: 0/255, blue: 18/255, alpha: 0.6)
        ],
        "土石流": [
            "警戒区域": UIColor(red: 255/255, green: 230/255, blue: 0/255, alpha: 0.6),
            "特別警戒区域": UIColor(red: 230/255, green: 0/255, blue: 18/255, alpha: 0.6)
        ],
        "地滑り": [
            "警戒区域": UIColor(red: 255/255, green: 230/255, blue: 0/255, alpha: 0.6),
            "特別警戒区域": UIColor(red: 230/255, green: 0/255, blue: 18/255, alpha: 0.6)
        ]
    ]
}



