//
//  DisasterViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class DisasterViewController: UIViewController {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedAreaNumber = appDelegate.commonData.selectedAreaNumber
        print("番号：\(selectedAreaNumber)")
        
        if selectedAreaNumber == 0 {
            print("現在地")
        }
        
        let LivingAreas = appDelegate.DBManager.getForLivingArea()
        let livingArea = LivingAreas[selectedAreaNumber-1] as AnyObject
        cityNameLabel.text = livingArea["cityName"] as! String
        
        let lat = livingArea["lat"] as! Double
        let lng = livingArea["lng"] as! Double
        print(lat)
        print(lng)
        mapView.setCameraLocation(lat, lng: lng)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
