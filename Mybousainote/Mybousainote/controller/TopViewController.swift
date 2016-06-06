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
    
    var livingAreas: [AnyObject]!
    
    @IBOutlet weak var debugTextView: UITextView!
    @IBOutlet weak var livingAreaView1: UIView!
    @IBOutlet weak var livingAreaView2: UIView!
    @IBOutlet weak var livingAreaView3: UIView!
    @IBOutlet weak var livingAreaView4: UIView!
    
    
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
        livingAreas = appDelegate.DBManager.getForLivingArea()
        
        var num = 0
        
        for livingArea in livingAreas {
            num += 1
            
            let cityName = livingArea["cityName"] as! String
            
            let livingAreaButton = LivingAreaButton()
            livingAreaButton.rank = num
            livingAreaButton.loadXib()
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
            appDelegate.global.selectedArea = livingAreas[button.tag-1] as! NSObject
        }
        else {
            print("現在地")
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

//        appDelegate.DBManager.deleteOldDataFromLocationTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
