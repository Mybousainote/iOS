//
//  LogViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/11/02.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class LogViewController: UIViewController {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var logMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locations = appDelegate.DBManager.getLocationLog()
        setPolyline(locations)
    }
    
    func setPolyline(points: [AnyObject]) {
        let path = GMSMutablePath()
        
        for point in points {
            let lat = point["lat"] as! Double
            let lng = point["lng"] as! Double
            path.addCoordinate(CLLocationCoordinate2DMake(lat, lng))
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor(red: 0/255, green: 102/255, blue: 102/255, alpha: 0.5)
        polyline.strokeWidth = 5.0
        polyline.map = self.logMapView
        
        //軌跡がおさまるズームサイズに変更する
        let bouds: GMSCoordinateBounds = GMSCoordinateBounds().includingPath(path)
        let cameraUpdate: GMSCameraUpdate = GMSCameraUpdate.fitBounds(bouds, withPadding: 30)
        self.logMapView.animateWithCameraUpdate(cameraUpdate)
    }
    
    @IBAction func touchedCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
