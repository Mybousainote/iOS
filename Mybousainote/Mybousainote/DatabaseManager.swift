//
//  DatabaseManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import RealmSwift

class Location_Table: Object {
    dynamic var createdDate: NSDate = NSDate()
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
}

class CityFrequency_Table: Object {
    dynamic var cityName: String = ""
    dynamic var frequency: Int = 0
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
}

protocol DatabaseManagerDelegate {
    func didGettedData(data: NSString)
}

class DatabaseManager: NSObject {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var delegate: DatabaseManagerDelegate!
    
    override init() {
        super.init()
        showTableContent(Location_Table)
        showTableContent(CityFrequency_Table)
        
        //        deleteTable(CityFrequency_Table)
    }
    
    //指定したテーブルの中身を表示
    func showTableContent(tableObject: Object.Type) {
        let myRealm = try! Realm()
        let tableContain = myRealm.objects(tableObject)
        print("----- ▼ テーブルの中身 -----")
        print(tableContain)
        print("----- ▲ テーブルの中身 -----")
    }
    
    //指定したテーブルを削除
    func deleteTable(tableObject: Object.Type) {
        let myRealm = try! Realm()
        let table = myRealm.objects(tableObject)
        try! myRealm.write {
            myRealm.delete(table)
        }
    }
    
    //テーブルを全削除する
    func deleteAllTable() {
        let myRealm = try! Realm()
        try! myRealm.write {
            myRealm.deleteAll()
        }
    }
    
    //取得した位置情報をDBに保存する
    func insertLocationTable(lat: Double, lng: Double) {
        let myLocations = Location_Table()
        
        myLocations.createdDate = NSDate()
        myLocations.lat = lat
        myLocations.lng = lng
        
        print("【保存】緯度：\(lat) 経度：\(lng) 時間：\(myLocations.createdDate)")
        
        let myRealm = try! Realm()
        try! myRealm.write {
            myRealm.add(myLocations)
        }
    }
    
    //頻度を更新する
    func refreshCityFrequency() {
        //既存のテーブルを削除
        deleteTable(CityFrequency_Table)
        
        //位置情報履歴を取得
        let myRealm = try! Realm()
        let rows = myRealm.objects(Location_Table) //← ここで時間のフィルターをかける必要あり
        
        for row in rows {
            let lat = row.lat
            let lng = row.lng
            appDelegate.lManager.revGeocoding(lat, lng: lng)
        }
    }
    
    //変換された地名と頻度をテーブルに保存
    func insertFrequencyTable(cityName: String, lat: Double, lng: Double) {
        
        let myRealm = try! Realm()
        
        //指定した地名がある場合は頻度を取り出す
        let rows = myRealm.objects(CityFrequency_Table).filter("cityName = '\(cityName)'")
        
        var frequency = 0
        
        for row in rows {
            frequency = row.frequency
            
            //行を削除
            try! myRealm.write {
                myRealm.delete(row)
            }
        }
        
        //市町名と頻度をテーブルに保存
        let myFrequencies = CityFrequency_Table()
        myFrequencies.cityName = cityName
        myFrequencies.frequency = frequency + 1
        myFrequencies.lat = lat
        myFrequencies.lng = lng
        
        try! myRealm.write {
            myRealm.add(myFrequencies)
        }
        
        print("【保存】地名：\(cityName) 頻度：\(frequency)")
    }
    
    //上位4つの地域の情報を取得
    func getForLivingArea() -> [AnyObject] {
        let livingAreas = [
            [
                "cityName": "日野市旭が丘",
                "lat": 35.132,
                "lng": 132
            ]
        ]
        
        return livingAreas
    }
}




