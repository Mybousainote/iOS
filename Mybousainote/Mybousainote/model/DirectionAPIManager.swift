//
//  DirectionAPIManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol DirectionAPIManagerDelegate {
    optional func didGetRoutes(routes: AnyObject)
}

class DirectionAPIManager: NSObject {
    
    var delegate: DirectionAPIManagerDelegate!
    
    override init() {
        super.init()
    }
    
    //ルート情報を取得
    func getRoutesData(originLat: Double, originLng: Double, destinationLat: Double, destinationLng: Double) {
        print("ルートを取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLat),\(originLng)&destination=\(destinationLat),\(destinationLng)&mode=walking&key=\(Config().googleAPIKey)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功！")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers))
                        
                        let routes = json!["routes"]
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            self.delegate.didGetRoutes!(routes!!)
                        }
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
}
