//
//  SedimentsView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/07/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SedimentsView: UIView {

    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setInformation(name: String) {
        
    }
    
    class func instance() -> SedimentsView {
        return UINib(nibName: "SedimentsView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! SedimentsView
    }
}
