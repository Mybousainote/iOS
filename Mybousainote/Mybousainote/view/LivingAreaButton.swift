//
//  LivingAreaButton.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/14.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class LivingAreaButton: UIButton {
    
    @IBOutlet weak var streetView: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    class func instance() -> LivingAreaButton {
        return UINib(nibName: "LivingAreaButton", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! LivingAreaButton
    }
    
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
    
    func setUI() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }

    func setLocationName(name: String) {
        cityName.text = name
    }
    
    func setRank(rank: Int) {
        rankView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/4))
        rankLabel.text = "\(rank)"
        rankLabel.font = UIFont.boldSystemFontOfSize(20)
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
//        let nib = UINib(nibName: "LivingAreaButton", bundle: bundle)
//        let view = nib.instantiateWithOwner(self, options: nil).first as! UIButton
//        
//        //ボタンの番号を設定
//        view.tag = rank
//        
//        //ターゲットを設定
//        view.addTarget(TopViewController(), action: #selector(TopViewController.touchedLivingAreaButton(_:)), forControlEvents: .TouchUpInside)
//        
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
