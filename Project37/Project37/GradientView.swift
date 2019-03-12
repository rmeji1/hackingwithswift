//
//  GradientView.swift
//  Project37
//
//  Created by robert on 3/11/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
  @IBInspectable var topColor: UIColor = .white
  @IBInspectable var bottomColor: UIColor = .black

  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  override func layoutSubviews() {
    (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
  }
}
