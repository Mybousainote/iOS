//
//  CurrentAreaButton.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/06/08.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class CurrentAreaButton: UIButton {

    @IBOutlet weak var streetView: UIImageView!
    @IBOutlet weak var currentPosition: UILabel!
    
    //コードから初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //SB/xibから初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUI()
        
        //ターゲットを設定
        self.addTarget(TopViewController(), action: #selector(TopViewController.touchedLivingAreaButton(_:)), forControlEvents: .TouchUpInside)
    }
    
    class func instance() -> CurrentAreaButton {
        return UINib(nibName: "CurrentAreaButton", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! CurrentAreaButton
    }
    
    func setUI() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    func setLocationName() {
        currentPosition.font = UIFont.boldSystemFontOfSize(18)
    }
    
    func setStreetViewImage(lat: Double, lng: Double, width: CGFloat, height: CGFloat) {
        let apiKey = "AIzaSyCslSIWQG0dnhS8BaeCIQyUxttCliecBdA"
        let heading = arc4random_uniform(360)
        let urlString = "http://maps.googleapis.com/maps/api/streetview?size=\(Int(width*2))x\(Int(height*2))&location=\(lat),\(lng)&heading=\(heading)&pitch=-0.76&sensor=true&fov=90&key=\(apiKey)"
        
        print("ストリートビュー画像の取得: "+urlString)
        let url = NSURL(string: urlString)
        let req = NSURLRequest(URL:url!)
        
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data!)
            // 画像に対する処理 (UcellのUIImageViewに表示する等)
            self.streetView.image = image
            self.addSubview(self.streetView)
            self.sendSubviewToBack(self.streetView)
        }
    }
    
    
//    func loadXib() {
//        let  bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "CurrentAreaButton", bundle: bundle)
//        let view = nib.instantiateWithOwner(self, options: nil).first as! UIButton
//        
//        //ボタンの番号を設定
//        view.tag = rank
//        
//        //ターゲットを設定
//        //        view.addTarget(TopViewController(), action: #selector(TopViewController.transitionToDisasterView), forControlEvents: .TouchUpInside)
//        
//        view.addTarget(TopViewController(), action: #selector(TopViewController.touchedLivingAreaButton(_:)), forControlEvents: .TouchUpInside)
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
