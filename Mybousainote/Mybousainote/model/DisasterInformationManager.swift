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
        
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        
        let url = "http://taigasano.com/mybousainote/api/test.php?prefecture=%E6%9D%B1%E4%BA%AC%E9%83%BD%E6%97%A5%E9%87%8E%E5%B8%82"
        
        manager.GET(url, parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                print("Success!!")
                
                let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers)) as? NSArray
                print(json)
                print(json![0])
                print((json![0] as AnyObject)["name"])
            },
            failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                print("Error!!")
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
