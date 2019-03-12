//
//  ViewController.swift
//  project22
//
//  Created by robert on 2/15/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  @IBOutlet weak var distanceReading: UILabel!
  var locationManager: CLLocationManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = CLLocationManager()
    locationManager.delegate = self
    // non-blocking call
    locationManager.requestAlwaysAuthorization()
    
    view.backgroundColor = .gray
  }

  func startScanning(){
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")
    let beconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 123, minor: 456, identifier: "MyBeacon")
    
    locationManager.startMonitoring(for: beconRegion)
    locationManager.startRangingBeacons(in: beconRegion)
  }
  
  func update(distance: CLProximity) {
    UIView.animate(withDuration: 0.8){[unowned self] in
      switch distance {
      case .unknown:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKOWN"
      case .near:
        self.view.backgroundColor = .orange
        self.distanceReading.text = "NEAR"
      case .immediate:
        self.view.backgroundColor = .red
        self.distanceReading.text = "RIGHT HERE"
      case .far:
        self.view.backgroundColor = .blue
        self.distanceReading.text = "FAR"
      }
    }
  }

}

extension ViewController: CLLocationManagerDelegate{
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if beacons.count > 0 {
      let beacon = beacons[0]
      update(distance: beacon.proximity)
    }else{
      update(distance: .unknown)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways{ // if we were given authorized always 
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
        if CLLocationManager.isRangingAvailable(){
          // dosomething
          startScanning()
        }
      }
    }
  }
}
