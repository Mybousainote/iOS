//
//  DisasterInformationManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/02.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol DisasterInformationManagerDelegate {
    optional func didGetFacilitiesData(facilities: [AnyObject])
    optional func didGetFacilityDataFromId(facility: AnyObject)
    optional func didGetEarthquakeData(earthquake: AnyObject)
    optional func didGetFloodsData(floods: [AnyObject])
    optional func didGetWaterDepth(waterDepth: String)
    optional func didGetSedimentsData(sediments: [AnyObject])
    optional func didGetSedimentType(sedimentType: String)
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
                        if json != nil {
                            self.delegate.didGetEarthquakeData!(json!)
                        }
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
                if json != nil {
                    self.delegate.didGetFacilitiesData!(json as! [AnyObject])
                }
            },
            failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                print("エラー！")
                print(operation?.responseObject)
                print(operation?.responseString)
            }
        )
    }
    
    //指定したIDの避難施設情報を取得
    func getFacilityDataFromId(id: Int) {
        print("ID:\(id) の避難施設情報を取得")
        
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/facilities/get-from-id.php?id=\(id)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers))
                        
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            self.delegate.didGetFacilityDataFromId!(json!)
                        }
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
    
    //浸水情報を取得
    func getFloodsData(lat: Double, lng: Double, rectSize: Double) {
        print("浸水情報を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/floods/?lat=\(lat)&lng=\(lng)&rect-size=\(rectSize)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers)) as? NSArray
                        
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            self.delegate.didGetFloodsData!(json as! [AnyObject])
                        }
                        
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
    
    //中心点の浸水深を取得
    func getWaterDepth(lat: Double, lng: Double) {
        print("中心点の浸水深を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/floods/get-waterdepth.php?lat=\(lat)&lng=\(lng)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers))
                        
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            //値を取得
                            let waterDepth = json!["waterDepth"] as! String
                            self.delegate.didGetWaterDepth!(waterDepth)
                        }
                        
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
    
    //土砂情報を取得
    func getSedimentsData(lat: Double, lng: Double, rectSize: Double) {
        print("土砂情報を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/sediments/?lat=\(lat)&lng=\(lng)&rect-size=\(rectSize)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers)) as? NSArray
                        
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            self.delegate.didGetSedimentsData!(json as! [AnyObject])
                        }
                        
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
    
    
    //中心点の土砂災害の種別を取得
    func getSedimentType(lat: Double, lng: Double) {
        print("中心点の土砂災害の種別を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/sediments/get-sedimenttype.php?lat=\(lat)&lng=\(lng)"
        
        print(url)
        let encodeURL: String! = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        manager.GET(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                        print("取得に成功")
                        
                        let json = (try? NSJSONSerialization.JSONObjectWithData(responsobject as! NSData, options: .MutableContainers))
                        
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            //値を取得
                            let type = json!["type"] as! String
                            self.delegate.didGetSedimentType!(type)
                        }
                        
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
