//
//  ViewController.swift
//  Project16
//
//  Created by robert on 2/12/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let label: UILabel = {
    let label = UILabel()
    label.text = "Hello World"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    label.heightAnchor.constraint(equalToConstant: 24)
//    label.widthAnchor.constraint(equalToConstant: 48)
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
  }
}

