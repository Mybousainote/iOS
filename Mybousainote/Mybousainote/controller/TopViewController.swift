//
//  TopViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, DatabaseManagerDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var debugTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //データベース管理用クラスの作成
        appDelegate.dbManager.initializeDatabase()
        //位置情報許可の申請
        appDelegate.lManager.requestAuthorization()
        
        
        
        appDelegate.dbManager.delegate = self
    }
    
    func didGettedData(data: NSString) {
//        print("\(data)")
//        debugTextView.text = "\(data)";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
