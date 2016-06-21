//
//  FloodsView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/21.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class FloodsView: UIView {

    @IBOutlet weak var label: UILabel!
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setInformation(name: String) {
        label.text = name
    }
    
    class func instance() -> FloodsView {
        return UINib(nibName: "FloodsView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! FloodsView
    }
}
