//
//  FloodsView.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/21.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

protocol FloodsViewDelegate {
    func didTouchedReloadButton()
}

class FloodsView: UIView {
    
    //デリゲート設定
    var delegate: FloodsViewDelegate!
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var m: UILabel!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var sideView: UIView!
    
    @IBOutlet weak var depthNum: UILabel!
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func stylingBoldFont() {
        title1.font = UIFont.boldSystemFontOfSize(16)
        title2.font = UIFont.boldSystemFontOfSize(25)
        m.font = UIFont.boldSystemFontOfSize(15)
        caption.font = UIFont.boldSystemFontOfSize(12)
        depthNum.font = UIFont.boldSystemFontOfSize(22)
        
        if self.frame.width == 320 {
            sideView.translatesAutoresizingMaskIntoConstraints = true
            sideView.frame = CGRectMake(sideView.frame.minX-12, sideView.frame.minY-10, sideView.frame.width, sideView.frame.height)
        }
    }
    
    func setInformation(depth: String) {
        depthNum.text = depth
        depthNum.font = UIFont.boldSystemFontOfSize(22)
    }
    
    class func instance() -> FloodsView {
        return UINib(nibName: "FloodsView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! FloodsView
    }
    
    @IBAction func touchedReloadButton(sender: AnyObject) {
        self.delegate.didTouchedReloadButton()
    }
}
