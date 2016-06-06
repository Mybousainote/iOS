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
}

class DisasterInformationManager: NSObject {
    
    var delegate: DisasterInformationManagerDelegate!
    
    override init() {
        super.init()
    }

    
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
//                print(json)
//                print(json![0])
//                print((json![0] as AnyObject)["name"])
                
//                for object in json! {
//                    print(object["name"])
//                }
                
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
