//
//  EarthquakeView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/15.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class EarthquakeView: UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var fiveLow: UILabel!
    @IBOutlet weak var fiveStrong: UILabel!
    @IBOutlet weak var sixLow: UILabel!
    @IBOutlet weak var sixStrong: UILabel!
    @IBOutlet weak var percent1: UILabel!
    @IBOutlet weak var percent2: UILabel!
    @IBOutlet weak var percent3: UILabel!
    @IBOutlet weak var percent4: UILabel!
    
    
    @IBOutlet weak var fiveLowNum: UILabel!
    @IBOutlet weak var fiveStrongNum: UILabel!
    @IBOutlet weak var sixLowNum: UILabel!
    @IBOutlet weak var sixStrongNum: UILabel!
    
    
    @IBOutlet weak var leftBottom: UIView!
    @IBOutlet weak var rightBottom: UIView!
    
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
        fiveLow.font = UIFont.boldSystemFontOfSize(11)
        fiveStrong.font = UIFont.boldSystemFontOfSize(11)
        sixLow.font = UIFont.boldSystemFontOfSize(11)
        sixStrong.font = UIFont.boldSystemFontOfSize(11)
        percent1.font = UIFont.boldSystemFontOfSize(14)
        percent2.font = UIFont.boldSystemFontOfSize(14)
        percent3.font = UIFont.boldSystemFontOfSize(14)
        percent4.font = UIFont.boldSystemFontOfSize(14)
        
        
        if self.frame.width == 320 {
            leftBottom.translatesAutoresizingMaskIntoConstraints = true
            rightBottom.translatesAutoresizingMaskIntoConstraints = true
            
            leftBottom.frame = CGRectMake(0, 72, 138, 90)
            rightBottom.frame = CGRectMake(128, 72, 138, 90)
            
            title.translatesAutoresizingMaskIntoConstraints = true
            title.frame = CGRectMake(0, 0, 248, 15)
            title.center = CGPointMake(self.frame.width/2, 18)

        }
    }
    
    func setInformation(I45: String, I50: String, I55: String, I60: String) {
        fiveLowNum.text = I45
        fiveLowNum.font = UIFont.boldSystemFontOfSize(22)
        fiveStrongNum.text = I50
        fiveStrongNum.font = UIFont.boldSystemFontOfSize(22)
        sixLowNum.text = I55
        sixLowNum.font = UIFont.boldSystemFontOfSize(22)
        sixStrongNum.text = I60
        sixStrongNum.font = UIFont.boldSystemFontOfSize(22)
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
