//
//  CurrentAreaButton.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/08.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class CurrentAreaButton: UIButton {

    @IBOutlet weak var label: UILabel!
    var rank: Int = 0
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLocationName(name: String) {
        label.text = name
    }
    
    func loadXib() {
        let  bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LivingAreaButton", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIButton
        
        //ボタンの番号を設定
        view.tag = rank
        
        //ターゲットを設定
        //        view.addTarget(TopViewController(), action: #selector(TopViewController.transitionToDisasterView), forControlEvents: .TouchUpInside)
        
        view.addTarget(TopViewController(), action: #selector(TopViewController.touchedLivingAreaButton(_:)), forControlEvents: .TouchUpInside)
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
