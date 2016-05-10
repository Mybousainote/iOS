//
//  DisasterInformationManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/02.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import AFNetworking

class DisasterInformationManager: NSObject {
    
    override init() {
        super.init()
        
        
    }
    
    func testForAquireDisasterInformation() {
        print("防災情報取得テスト")
        
        print("同期？？")
        var URL:NSURL!
        URL = NSURL(string: "http://localhost:3001/test.json")
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        let json = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? NSDictionary
        print(json)
        
        print("うん同期")
        
        NSLog("AFNetwork Starts First Page!!!")

        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer

//        let serializer2:AFJSONRequestSerializer = AFJSONRequestSerializer()
//        manager.requestSerializer = serializer2
        
        let url = "http://localhost:3001/test.php"
        let url2 = ""
        
        manager.GET(url, parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                print("Success!!")
                
                let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: [])) as? NSDictionary
                print(json)
                print(json!["id"])
                
            },
            failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                print("Error!!")
                print(operation?.responseObject)
                print(operation?.responseString)
            }
        )
        
        print("非同期")
    }
}
