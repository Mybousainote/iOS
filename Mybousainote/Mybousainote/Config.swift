//
//  Config.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import Foundation

public class Config {
    //デバッグ用アラートを表示するか否か
    let isForDebug: Bool = false
    
    //位置情報履歴を保存する期間（日）
    let timeIntervalHoldData: Double = 30
    
    //避難施設を取得する中心点からの範囲（m）
    let getFacilitiesBound = 2000
    
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
}