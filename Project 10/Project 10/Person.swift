//
//  Person.swift
//  Project 10
//
//  Created by robert on 2/8/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class Person: NSObject {
  var image: String
  var name: String
  
  init(name: String, image: String){
    self.name = name
    self.image = image
  }
}
