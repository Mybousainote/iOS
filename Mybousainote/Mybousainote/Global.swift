//
//  Global.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit
import SVProgressHUD

public class Global: NSObject {
    //トップ画面で選択されたボタンの番号（0:現在地 1~4:生活圏）
//    var selectedAreaNumber: Int!
    
    //トップ画面で選択された地域のデータ（地名, 緯度, 経度）
    var selectedAreaObject: NSObject!
    
    //防災情報画面で選択された避難施設のID
    var selectedFacilityId: Int!
    
    //防災情報画面から避難施設詳細画面へ遷移するときの中心点の緯度経度
    var centerLat: Double!
    var centerLng: Double!
    
    
    var blackBgView: BlackBgView!
    
    //ローディング画面を表示
    func showLoadingView(view: UIView, messege: String) {
        blackBgView = BlackBgView.init(frame: view.frame)
        view.addSubview(blackBgView)
        SVProgressHUD.showWithStatus(messege)
    }
    
    //ローディング画面を削除
    func removeLoadingView() {
        blackBgView.removeFromSuperview()
        SVProgressHUD.dismiss()
    }
}