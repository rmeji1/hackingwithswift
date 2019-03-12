//
//  ViewController.swift
//  Project6b
//
//  Created by robert on 2/5/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let label1 : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.red
    label.text = "THESE"
    label.sizeToFit()
    return label
  }()
  
  let label2 : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.cyan
    label.text = "ARE"
    label.sizeToFit()
    return label
  }()
  
  let label3 : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.yellow
    label.text = "SOME"
    label.sizeToFit()
    return label
  }()
  
  let label4 : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.green
    label.text = "AWESOME"
    label.sizeToFit()
    return label
  }()
  
  let label5 : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.orange
    label.text = "LABELS"
    label.sizeToFit()
    return label
  }()
  
  ///Tells iOS we don't want the status bar visible for this VC
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let labels = [label1, label2, label3, label4, label5]
    labels.forEach{
      view.addSubview($0)
      
    }
    
/// adds constraints using Visual Format Language (VFL)
//    let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//    for label in viewsDictionary.keys {
//
//      view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//    }
//    // adds Visual Format Language (VFL)
//    let metrics = ["labelHeight": 88]
//    view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))
    var previousLabel: UILabel?
    
    label1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    label5.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10.0).isActive = true
    
    let heightAnchor =  label1.heightAnchor.constraint(equalToConstant: 88.0)
    heightAnchor.priority = .init(999.0)
    heightAnchor.isActive = true
  
    labels.forEach{
      $0.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
      if $0 != label1{
        $0.heightAnchor.constraint(equalTo:label1.heightAnchor ).isActive = true
      }
      if let previous = previousLabel{
        $0.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
      }
      previousLabel = $0
    }
  }
}

