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
  
  /// Required init for NSCoding
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as! String
    image = aDecoder.decodeObject(forKey: "image") as! String
  }
}

extension Person: NSCoding{
/// Required method for NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(image, forKey: "image")
  }
}
