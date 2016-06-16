//
//  EarthquakeView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/15.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class EarthquakeView: UIView {
    
    
    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var label: UILabel!
    
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
    
    class func instance() -> EarthquakeView {
        return UINib(nibName: "EarthquakeView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! EarthquakeView
    }
    
//    func loadXib() {
//        let  bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "EarthquakeView", bundle: bundle)
//        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
//        addSubview(view)
//        
//        // カスタムViewのサイズを自分自身と同じサイズにする
//        view.translatesAutoresizingMaskIntoConstraints = false
//        let bindings = ["view": view]
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
//            options:NSLayoutFormatOptions(rawValue: 0),
//            metrics:nil,
//            views: bindings))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
//            options:NSLayoutFormatOptions(rawValue: 0),
//            metrics:nil,
//            views: bindings))
//    }

}
