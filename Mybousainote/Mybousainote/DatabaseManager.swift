//
//  DatabaseManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import RealmSwift

protocol DatabaseManagerDelegate {
    func didGettedData(data: NSString)
}

class DatabaseManager: NSObject {
    
    var delegate: DatabaseManagerDelegate!
    
    
    func initializeDatabase() {
        print("データベースの初期設定をする")
        
        let realm = try! Realm()
        let test = realm.objects(Location_Table)
        
        let test2 = realm.objects(Location_Table).filter("lat > 0")
        for aaa in test2 {
//            print(aaa.cityName)
        }
        
//        print(test)
//        delegate.didGettedData("\(test)")
//        deleteLocationTable()
    }
    
    func deleteLocationTable() {
        let realm = try! Realm()
        let gettedTable = realm.objects(Location_Table)
        
        try! realm.write {
            realm.delete(gettedTable)
        }
    }
    
    
    //取得した位置情報をDBに保存する
    func insertLocationData(lat: Double, lng: Double, cityName: String, townName: String) {
        
        let myLocations = Location_Table()
        
        myLocations.lat = lat
        myLocations.lng = lng
        myLocations.cityName = cityName
        myLocations.townName = townName
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(myLocations)
        }
    }
}

class Fruits: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var detail:String? = nil
}

class Location_Table: Object {
//    dynamic var createdDate: NSDate = 0
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
    dynamic var cityName: String = ""
    dynamic var townName: String = ""
}

class region_frequency_table {
    dynamic var cityName: String = ""
    dynamic var frequency: Int = 0
}


