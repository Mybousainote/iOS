//
//  TopViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let ud = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var debugTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //位置情報許可時の画面遷移の判定用
        appDelegate.LManager.isTopView = true
        
        //位置情報が許可されてない場合アラートを表示
        if ud.boolForKey("LOCATION_AUTHORIZED") == false {
            let alert: UIAlertController = UIAlertController(title: "位置情報サービスが無効です", message: "設定 > プライバシー > 位置情報サービス から\"My防災ノート\"による位置情報の利用を許可してください", preferredStyle:  UIAlertControllerStyle.Alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        setLivingAreaButtons()
        
        
        
    }
    
    func setLivingAreaButtons() {
        let LivingAreas = appDelegate.DBManager.getForLivingArea()
        
        for livingArea in LivingAreas {
            let cityName = livingArea["cityName"] as! String
            print(cityName)
        }
    }

    @IBAction func test(sender: AnyObject) {
        //防災情報取得テスト
        appDelegate.DIManager.testForAquireDisasterInformation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
