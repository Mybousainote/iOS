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
    
    var livingAreaObjects: [AnyObject]!
    
    @IBOutlet weak var debugTextView: UITextView!
    
    @IBOutlet weak var currentAreaView: UIView!
    @IBOutlet weak var livingAreaView1: UIView!
    @IBOutlet weak var livingAreaView2: UIView!
    @IBOutlet weak var livingAreaView3: UIView!
    @IBOutlet weak var livingAreaView4: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初回画面からの画面遷移の判定用
        appDelegate.LManager.isTopView = true
        
        //現在地を取得
        appDelegate.LManager.locationManager.startUpdatingLocation()
        
        //地名と頻度のテーブルの更新（BackgroundFetchでも呼ばれるがここでも呼んでおく）
//        appDelegate.DBManager.refreshCityFrequency() ← 更新する際に一度テーブルを削除してややこしくなる
        
        checkLocationAuthorize()
    }
    
    //viewが全て読み込まれた後に呼ばれる
    override func viewDidLayoutSubviews() {
//        setLivingAreaButtons()
    }
    override func viewDidAppear(animated: Bool) {
        setCurrentAreaButton()
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
    
    //現在地ボタンを作成する
    func setCurrentAreaButton() {
        let currentAreaButton = CurrentAreaButton.instance()
        currentAreaButton.tag = 0
        currentAreaButton.setLocationName("現在地")
        currentAreaButton.frame = CGRectMake(0, 0, currentAreaView.frame.width, currentAreaView.frame.height)
        currentAreaView.addSubview(currentAreaButton)
    }
    
    //生活圏リストボタンを作成する
    func setLivingAreaButtons() {
        livingAreaObjects = appDelegate.DBManager.getForLivingArea()
        
        var num = 0
        
        for livingAreaObject in livingAreaObjects {
            num += 1
            
            let cityName = livingAreaObject["cityName"] as! String
            
            let livingAreaButton = LivingAreaButton.instance()
            livingAreaButton.tag = num
            livingAreaButton.setLocationName(cityName)
            
            switch num {
            case 1:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView1.frame.width, livingAreaView1.frame.height)
                livingAreaView1.addSubview(livingAreaButton)
                break
                
            case 2:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView2.frame.width, livingAreaView2.frame.height)
                livingAreaView2.addSubview(livingAreaButton)
                break
                
            case 3:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView3.frame.width, livingAreaView3.frame.height)
                livingAreaView3.addSubview(livingAreaButton)
                break
                
            case 4:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView4.frame.width, livingAreaView4.frame.height)
                livingAreaView4.addSubview(livingAreaButton)
                break
                
            default:
                break
            }
        }
    }
    
    //生活圏ボタンが押されたときに呼ばれる
    func touchedLivingAreaButton(button: UIButton) {        
        if button.tag != 0 {
            appDelegate.global.selectedAreaObject = livingAreaObjects[button.tag-1] as! NSObject
        }
        else {
            print("現在地")
            
            //現在地許可がされてないときの対処
            
            appDelegate.global.selectedAreaObject = [
                "cityName": "現在地",
                "lat": appDelegate.LManager.lat,
                "lng": appDelegate.LManager.lng
            ]
        }
        transitionToDisasterView()
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
        appDelegate.DIManager.getFloodsData(0, lng: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
