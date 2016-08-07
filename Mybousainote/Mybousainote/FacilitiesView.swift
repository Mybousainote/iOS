//
//  FacilitiesView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/22.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class FacilitiesView: UIView {
    
    class func instance() -> FacilitiesView {
        return UINib(nibName: "FacilitiesView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! FacilitiesView
    }
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setFacilitiesListButton(buttonInformations: NSArray) {
        
        var count: CGFloat = 0
        for buttonInformation in buttonInformations {
            let listButton = FacilitiesListButton.instance()
            
            
            let width = self.frame.width-20
            let height = (self.frame.height-8*3-10*2)/4
            
            listButton.frame = CGRectMake(10, 10+count*(height+8), width, height)
            listButton.name.text = buttonInformation["name"] as? String
            listButton.name.font = UIFont.boldSystemFontOfSize(18)
            listButton.tag = Int(buttonInformation["id"] as! String)!
            listButton.num.text = buttonInformation["num"] as? String
            listButton.num.font = UIFont.boldSystemFontOfSize(18)

            self.addSubview(listButton)
            
            count += 1
        }
    }
}
