//
//  View.swift
//  Project28
//
//  Created by robert on 2/22/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class View: UIView {
  let textView : UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.isHidden = true
    return textView
  }()
  
  let button : UIButton = {
    let button = UIButton(type: .roundedRect)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Authenticate", for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.addSubview(textView)
    self.addSubview(button)
    self.bringSubviewToFront(textView)
    
    activateTextViewConstriants()
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 100),
      button.heightAnchor.constraint(equalToConstant: 44),
      button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ])
  }
  
   required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  fileprivate func activateTextViewConstriants() {
    let layout = layoutMarginsGuide
    NSLayoutConstraint.activate([
      textView.widthAnchor.constraint(equalTo: widthAnchor),
      textView.heightAnchor.constraint(equalTo: layout.heightAnchor),
      textView.centerXAnchor.constraint(equalTo: centerXAnchor),
      textView.centerYAnchor.constraint(equalTo: layout.centerYAnchor)
      ])
  }
}
