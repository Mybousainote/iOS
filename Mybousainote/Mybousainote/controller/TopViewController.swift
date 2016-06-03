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
    @IBOutlet weak var livingAreaView1: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初回画面からの画面遷移の判定用
        appDelegate.LManager.isTopView = true
        
        //地名と頻度のテーブルの更新（BackgroundFetchでも呼ばれるがここでも呼んでおく）
//        appDelegate.DBManager.refreshCityFrequency() ← 更新する際に一度テーブルを削除してややこしくなる
        
        checkLocationAuthorize()
    }
    
    //viewが全て読み込まれた後に呼ばれる
    override func viewDidLayoutSubviews() {
//        setLivingAreaButtons()
    }
    override func viewDidAppear(animated: Bool) {
        setLivingAreaButtons()
    }
    
    //位置情報が許可されてない場合アラートを表示する
    func checkLocationAuthorize() {
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
    }
    
    //生活圏リストボタンを作成する
    func setLivingAreaButtons() {
        let LivingAreas = appDelegate.DBManager.getForLivingArea()
        
        for livingArea in LivingAreas {
            let cityName = livingArea["cityName"] as! String
            print(cityName)
        }
        
        //とりあえずテスト用で全部同じボタン
        let livingAreaButton = LivingAreaButton()
        livingAreaButton.frame = CGRectMake(0, 0, livingAreaView1.frame.width, livingAreaView1.frame.height)
        livingAreaView1.addSubview(livingAreaButton)
    }
    
    //防災情報画面へ遷移する
    func transitionToDisasterView() {
        print("防災情報画面へ遷移")
        let storyboard = UIStoryboard(name: "Disaster", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    
    
    
    
    
        	
    //テスト
    @IBAction func test(sender: AnyObject) {
        //防災情報取得テスト
        appDelegate.DIManager.testForAquireDisasterInformation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
