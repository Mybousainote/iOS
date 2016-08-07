//
//  Tutorial ViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, LocationManagerDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var startButton: UIButton!
    
    //アナリティクスのトラッカー
    let tracker = GAI.sharedInstance().defaultTracker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.LManager.delegate = self
    }
    
    @IBAction func didTouchedStartButton(sender: AnyObject) {
        print("スタート！")
        
        //位置情報許可の申請
        appDelegate.LManager.requestAuthorization()
    }
    
    func acceptAuthorization() {
        transitionToTopView()
    }
    
    func DeniedAuthorization() {
        transitionToTopView()
    }
    
    override func viewWillAppear(animated: Bool) {
        trackingScreen()
    }
    
    //スクリーンをトラッキング
    func trackingScreen() {
        tracker.set(kGAIScreenName, value: "チュートリアル")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    //トップ画面へ遷移
    func transitionToTopView() {
        print("トップ画面へ遷移")
        let storyboard = UIStoryboard(name: "Top", bundle: nil)
        let modalView: UIViewController! = storyboard.instantiateInitialViewController()
//        self.navigationController?.pushViewController(nextView, animated: true)
        self.presentViewController(modalView, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
