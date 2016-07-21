//
//  InformationViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/21.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import Onboard

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        setContents()
    }
    
    func setContents() {
        
//        let bgImageURL = NSURL(string: "https://www.pakutaso.com/shared/img/thumb/KAZ_hugyftdrftyg_TP_V.jpg")!
//        let bgImage = UIImage(data: NSData(contentsOfURL: bgImageURL)!)
        
        
        let content1 = OnboardingContentViewController(
            title: "Title1",
            body: "Body1",
            image: nil,
            buttonText: "アンケートのお願い",
            action: {
                print("アンケートを表示")
            }
        )
        let content2 = OnboardingContentViewController(
            title: "Title2",
            body: "Body2",
            image: nil,
            buttonText: "",
            action: nil
        )
        
        
        let vc = OnboardingViewController(
            backgroundImage: nil,
            contents: [content1, content2]
        )
        vc.allowSkipping = true
        vc.skipHandler = { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    @IBAction func touchedBackButton(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        
        setContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
