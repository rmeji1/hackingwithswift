//
//  ViewController.swift
//  Coordinators
//
//  Created by robert on 1/27/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Storyboarded  {
  weak var coordinator: MainCoordinator?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func buyTapped(_ sender: Any) {
    coordinator?.buySubscription()
  }
  
  @IBAction func createAccountTapped(_ sender: Any) {
    coordinator?.createAccount()
  }
}

