//
//  ext+UIButton.swift
//  Project2
//
//  Created by robert on 12/27/18.
//  Copyright © 2018 Mejia. All rights reserved.
//

import UIKit

extension UIButton{
  convenience init(type: UIButton.ButtonType, height: CGFloat, width: CGFloat){
    self.init(type: type)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.lightGray.cgColor
    
//    self.layer.shadowRadius = 3
//    self.layer.shadowColor = UIColor.black.cgColor
  }
  
  func setContraintsFor(top: NSLayoutYAxisAnchor,by constant: CGFloat, centerX: NSLayoutXAxisAnchor ){
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: top, constant: constant),
      self.centerXAnchor.constraint(equalTo: centerX)
      ])
  }
}
