//
//  Coordinator.swift
//  FriendZone
//
//  Created by robert on 1/28/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

protocol Coordinator {
  var childCoordinator: [Coordinator] {get set}
  var navigationController: UINavigationController {get set}
  
  func start()
}
