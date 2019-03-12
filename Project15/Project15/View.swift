//
//  View.swift
//  Project15
//
//  Created by robert on 2/12/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class View: UIView {
  let button: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Tap", for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
    addSubviews()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addSubviews(){
    [button].forEach{
      self.addSubview($0)
    }
  }
  
  func addConstraints(){
    let allContstraints = buttonConstraints()
    NSLayoutConstraint.activate(allContstraints)
  }
  
  func buttonConstraints() -> [NSLayoutConstraint]{
    return [
      button.widthAnchor.constraint(equalToConstant: 46),
      button.heightAnchor.constraint(equalToConstant: 44),
      button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50)
    ]
  }
}
