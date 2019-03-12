//
//  Coordinator.swift
//  Coordinators
//
//  Created by robert on 1/27/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] {get set}
  var navigationController: UINavigationController {get set}
  
  func start()
}
