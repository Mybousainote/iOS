//
//  LivingAreaButton.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/14.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class LivingAreaButton: UIButton {
    
    @IBOutlet weak var label: UILabel!
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func loadXib() {
        let  bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LivingAreaButton", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIButton
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
    }
}
