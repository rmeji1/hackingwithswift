//
//  ViewController.swift
//  project19
//
//  Created by robert on 2/13/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  var captials = [Capital]()
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the city of light.")
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
    let wasingtonDC = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
    captials = [london,oslo,paris,rome,wasingtonDC]
    mapView.addAnnotations(captials)
  }
}

extension ViewController: MKMapViewDelegate{
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "Capital"
    
    if annotation is Capital{
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      
      if annotationView == nil{
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = true
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView!.rightCalloutAccessoryView = btn
      }else{
        annotationView!.annotation = annotation
      }
      
      return annotationView
    }
    
    return nil
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let capital = view.annotation as! Capital
    let placeName = capital.title
    let placeInfo = capital.info
    
    let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    present(ac,animated: true)
  }
}

