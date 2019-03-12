//
//  MainCoordinator.swift
//  Coordinators
//
//  Created by robert on 1/27/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator{
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  
  init(with navigationController: UINavigationController){
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = ViewController.instantiate()
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func buySubscription(){
    let vc = BuyViewController.instantiate()
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func createAccount(){
    let vc = CreateAccountViewController.instantiate()
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
}
