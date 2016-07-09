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
    
    //ステータスバーを白くする
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //viewが全て読み込まれた後に呼ばれる
    override func viewDidLayoutSubviews() {
//        setLivingAreaButtons()
    }
    override func viewDidAppear(animated: Bool) {
        setLivingAreaBg()
        setCurrentAreaButton()
        setLivingAreaButtons()
    }
    
    //各ボタンの背景を作成
    func setLivingAreaBg() {
        var livingAreaBg = UIView()
        livingAreaBg.frame = CGRectMake(0, 0, livingAreaView1.frame.width, livingAreaView1.frame.height)
        livingAreaBg = stylingAreaBg(livingAreaBg)
        
        livingAreaView1.addSubview(livingAreaBg)
        livingAreaView2.addSubview(livingAreaBg)
        livingAreaView3.addSubview(livingAreaBg)
        livingAreaView4.addSubview(livingAreaBg)
        
        var currentAreaBg = UIView()
        currentAreaBg.frame = CGRectMake(0, 0, currentAreaView.frame.width, currentAreaView.frame.height)
        currentAreaBg = stylingAreaBg(currentAreaBg)
        currentAreaView.addSubview(currentAreaBg)
    }
    
    func stylingAreaBg(view: UIView) -> UIView {
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4).CGColor
        view.layer.borderWidth = 4;
        
        return view
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
        currentAreaButton.setStreetViewImage(appDelegate.LManager.lat, lng: appDelegate.LManager.lng, width: currentAreaView.frame.width, height: currentAreaView.frame.height-(20+7*2))
        currentAreaButton.frame = CGRectMake(0, 0, currentAreaView.frame.width, currentAreaView.frame.height)
        currentAreaView.addSubview(currentAreaButton)
        
        addShadowAreaView(currentAreaView)
    }
    
    //生活圏リストボタンを作成する
    func setLivingAreaButtons() {
        //DBから生活圏上位4つを取得
        livingAreaObjects = appDelegate.DBManager.getFourLivingArea()
        
        var num = 0
        
        for livingAreaObject in livingAreaObjects {
            num += 1
            
            //情報を取得
            let subLocality = livingAreaObject["subLocality"] as! String
            let lat = livingAreaObject["lat"] as! Double
            let lng = livingAreaObject["lng"] as! Double
            
            let livingAreaButton = LivingAreaButton.instance()
            livingAreaButton.tag = num
            livingAreaButton.setLocationName(subLocality)
            livingAreaButton.setStreetViewImage(lat, lng: lng, width: livingAreaView1.frame.width, height: livingAreaView1.frame.height-(20+7*2))
            livingAreaButton.setRank(num)
            
            switch num {
            case 1:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView1.frame.width, livingAreaView1.frame.height)
                addShadowAreaView(livingAreaView1)
                livingAreaView1.addSubview(livingAreaButton)
                break
                
            case 2:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView2.frame.width, livingAreaView2.frame.height)
                addShadowAreaView(livingAreaView2)
                livingAreaView2.addSubview(livingAreaButton)
                break
                
            case 3:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView3.frame.width, livingAreaView3.frame.height)
                addShadowAreaView(livingAreaView3)
                livingAreaView3.addSubview(livingAreaButton)
                break
                
            case 4:
                livingAreaButton.frame = CGRectMake(0, 0, livingAreaView4.frame.width, livingAreaView4.frame.height)
                addShadowAreaView(livingAreaView4)
                livingAreaView4.addSubview(livingAreaButton)
                break
                
            default:
                break
            }
        }
    }
    
    func addShadowAreaView(view: UIView) {
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor
        view.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false
    }
    
    //生活圏ボタンが押されたときに呼ばれる
    func touchedLivingAreaButton(button: UIButton) {
        if button.tag != 0 {
            appDelegate.global.selectedAreaObject = livingAreaObjects[button.tag-1] as! NSObject
        }
        else {
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

    
    
    
    
    
    
    
    
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
