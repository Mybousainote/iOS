//
//  FacilitiesListView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/06.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class FacilitiesListButton: UIButton {
    
    class func instance() -> FacilitiesListButton {
        return UINib(nibName: "FacilitiesListButton", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! FacilitiesListButton
    }
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var num: UILabel!
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //ターゲット設定
        self.addTarget(DisasterViewController(), action: #selector(DisasterViewController.touchedFacilitiesListButton(_:)), forControlEvents: .TouchUpInside)
    }
    
}
