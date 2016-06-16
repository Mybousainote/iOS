//
//  DisasterInformationManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/02.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import AFNetworking

protocol DisasterInformationManagerDelegate {
    func didGetFacilitiesData(facilities: [AnyObject])
    func didGetEarthquakeData(earthquake: AnyObject)
}

class DisasterInformationManager: NSObject {
    
    var delegate: DisasterInformationManagerDelegate!
    
    override init() {
        super.init()
    }
    
    //地震情報を取得
    func getEarthquakeData(lat: Double, lng: Double) {
        print("地震情報を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://www.j-shis.bosai.go.jp/map/api/pshm/Y2016/AVR/TTL_MTTL/meshinfo.geojson?position=\(lng),\(lat)&epsg=4612"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers))
                        
                        //デリゲートメソッドを呼ぶ
                        self.delegate.didGetEarthquakeData(json!)
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
    
    //避難施設情報を取得
    func getFacilitiesData(lat: Double, lng: Double, length: Int) {
        print("避難施設情報を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/facilities/?lat=\(lat)&lng=\(lng)&length=\(length)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                print("取得に成功")
                
                let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers)) as? NSArray
                
                //デリゲートメソッドを呼ぶ
                self.delegate.didGetFacilitiesData(json as! [AnyObject])
            },
            failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                print("エラー！")
                print(operation?.responseObject)
                print(operation?.responseString)
            }
        )
    }
    
    func APITest() {
        print("同期通信テスト")
        var URL:NSURL!
        URL = NSURL(string: "http://localhost:3001/test.json")
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        let json = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? NSDictionary
        print(json)
    }
}
