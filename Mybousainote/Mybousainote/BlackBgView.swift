//
//  LoadingView.swift
//  iot-project
//
//  Created by TaigaSano on 2015/10/19.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit

class BlackBgView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.3
    }
}
