//
//  Config.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit

public class Config {
    //デバッグ用アラートを表示するか否か
    let isForDebug: Bool = false
    
    //位置情報履歴を保存する期間（日）
    let timeIntervalHoldData: Double = 30
    
    //避難施設を取得する中心点からの範囲（m）
    let getFacilitiesBound: Int = 3000
    
    //浸水情報を取得する正方形の一片の長さ（緯度経度数）
    let getFloodsRectSize: Double = 0.1
    
    //避難施設マーカーを表示するズームレベルの閾値
    let thresholdShowMarkerZoomLevel: Float = 12
    
    //仮想ペルソナの生活圏を表示するか否か
    let isVirtualPersona: Bool = true
    
    //仮想ペルソナの生活圏
    let virtualLivingArea: [AnyObject] = [
        [
            "cityName": "鎌倉市大船", //自宅
            "lat": 35.317931,
            "lng": 139.499904
        ],
        [
            "cityName": "鎌倉市津西", //勤務地
            "lat": 35.353113,
            "lng": 139.538310
        ],
        [
            "cityName": "鎌倉市鎌倉山", //よく行くカフェ
            "lat": 35.318271,
            "lng": 139.514939
        ],
        [
            "cityName": "鎌倉市小町", //スポーツクラブ
            "lat": 35.318734,
            "lng": 139.552864
        ]
    ]
    
    //各浸水深の値
    let warterDepthValues: AnyObject = [
        "0": "0",
        
        "11": "0～0.5ｍ未満",
        "12": "0.5～1.0ｍ未満",
        "13": "1.0～2.0ｍ未満",
        "14": "2.0～5.0ｍ未満",
        "15": "5.0ｍ以上",
        
        "21": "0～0.5ｍ未満",
        "22": "0.5～1.0ｍ未満",
        "23": "1.0～2.0ｍ未満",
        "24": "2.0～3.0ｍ未満",
        "25": "3.0～4.0ｍ未満",
        "26": "4.0～5.0ｍ未満",
        "27": "5.0ｍ以上"
    ]
    
    //各浸水深の色
    let warterDepthColors: AnyObject = [
        "11": UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.3), //0～0.5ｍ未満（5段階）
        "12": UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 0.3), //0.5～1.0ｍ未満（5段階）
        "13": UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 0.3), //1.0～2.0ｍ未満（5段階）
        "14": UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.3), //2.0～5.0ｍ未満（5段階）
        "15": UIColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 0.3), //5.0ｍ以上（5段階）

        "21": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3), //0～0.5ｍ未満（7段階）
        "22": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3), //0.5～1.0ｍ未満（7段階）
        "23": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3), //1.0～2.0ｍ未満（7段階）
        "24": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3), //2.0～3.0ｍ未満（7段階）
        "25": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3), //3.0～4.0ｍ未満（7段階）
        "26": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3), //4.0～5.0ｍ未満（7段階）
        "27": UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.3) //5.0ｍ以上（7段階）
    ]
}



