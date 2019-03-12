//
//  MainCoordinator.swift
//  FriendZone
//
//  Created by robert on 1/28/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator{
  var childCoordinator = [Coordinator]()
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = ViewController.instantiate()
    navigationController.pushViewController(vc, animated: false)
  }
  
  func configure(friend: Friend){
    let vc = FriendViewController.instantiate()
    vc.coordinator = self
    vc.friend = friend
    navigationController.pushViewController(vc, animated: true)
  }
  
  func update(friend: Friend){
    guard let vc = navigationController.viewControllers.first as? ViewController else{
      return
    }
    vc.update(friend: friend)
  }
}
