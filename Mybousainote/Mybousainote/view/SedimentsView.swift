//
//  SedimentsView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SedimentsView: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var type3: UILabel!
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func stylingBoldFont() {
        title.font = UIFont.boldSystemFontOfSize(15)
        type1.font = UIFont.boldSystemFontOfSize(22)
        type2.font = UIFont.boldSystemFontOfSize(22)
        type3.font = UIFont.boldSystemFontOfSize(22)
    }
    
    func setInformation(num: String) {
        type1.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
         type2.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
         type3.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
        switch num {
        case "1":
            type1.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            break
        case "2":
            type2.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            break
        case "3":
            type3.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            break
        default:
            break
        }
    }
    
    class func instance() -> SedimentsView {
        return UINib(nibName: "SedimentsView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! SedimentsView
    }
}
