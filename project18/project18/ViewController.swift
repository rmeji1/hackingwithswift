//
//  ViewController.swift
//  project18
//
//  Created by robert on 2/13/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    print("I'm inside the viewDidLoad() method!")
    print(1,2,3,4,5)
    print("Some message", terminator: "")
    print(1,2,3,4,5, separator: "-")
    
    assert(1==1, "Maths failure")
//    assert(1==2, "Maths failure")
    
    // debugging with breakpoints
    for i in 1...100{
      print("Got number \(i)")
    }
  }


}

