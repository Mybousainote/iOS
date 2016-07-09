//
//  FacilityInformationViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/06.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class FacilityInformationViewController: UIViewController, DisasterInformationManagerDelegate {
    
    @IBOutlet weak var testText: UITextView!
    
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var DIManager: DisasterInformationManager!
    
    //ストリートビュー
    @IBOutlet weak var streetView: StreetView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //デリゲート設定
        DIManager = DisasterInformationManager.init()
        DIManager.delegate = self
        
        //避難施設のIDを取得
        let id = appDelegate.global.selectedFacilityId as! Int
        
        //IDから情報を取得
        DIManager.getFacilityDataFromId(id)
    }
    
    
    //避難施設情報を取得したときに呼ばれる
    func didGetFacilityDataFromId(facility: AnyObject) {
        print(facility)
        
        let lat = Double(facility["lat"] as! String)
        let lng = Double(facility["lng"] as! String)
        
        //ストリートビューをセット
        streetView.setCameraPosition(lat!, lng: lng!)
        
//        let tsunamiHazard = facility["tsunamiHazard"] as! String
//        let volcanicHazard = facility["volcanicHazard"] as! String
//        let windAndFloodDamage = facility["windAndFloodDamage"] as! String
//        let earthquakeHazard = facility["earthquakeHazard"] as! String
        
        //各情報の抜き出し
        let name = facility["name"] as! String
        let address = facility["address"] as! String
        let facilityType = facility["facilityType"] as! String
        let seatingCapacity = facility["seatingCapacity"] as! String
        let facilityScale = facility["facilityScale"] as! String
        
        testText.text = name+"\n"+address+"\n"+facilityType+"\n"+seatingCapacity+"\n"+facilityScale
        print(name+"\n"+address+"\n"+facilityType+"\n"+seatingCapacity+"\n"+facilityScale)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func touchedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
