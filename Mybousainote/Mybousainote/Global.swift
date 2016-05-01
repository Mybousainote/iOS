//
//  Global.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import Foundation

//public class Global: NSObject {
//    
//    //アラートを出す
//    func showAlert(title: String?, message: String?) {
//        let alert = UIAlertView()
//        if title != nil {
//            alert.title = title!
//        }
//        if message != nil {
//            alert.message = message
//        }
//        alert.addButtonWithTitle("OK")
//        alert.show()
//    }
//    
//    //デバッグ用のアラートを出す
//    func showAlertForDebug(title: String?, message: String?) {
//        if Config().isForDebug == true {
//            let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "保存してもいいですか？", preferredStyle:  UIAlertControllerStyle.Alert)
//            
//            if title != nil {
//                alert.title = title!
//            }
//            if message != nil {
//                alert.message = message
//            }
//            alert.addButtonWithTitle("OK")
//            alert.show()
//        }
//    }
//}