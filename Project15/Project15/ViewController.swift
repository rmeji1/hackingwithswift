//
//  ViewController.swift
//  Project15
//
//  Created by robert on 2/12/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  unowned var tap: UIButton { return (view as! View).button  }
  var imageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "penguin"))
    imageView.center = CGPoint(x: 512, y: 384)
    return imageView
  }()
  var currentAnimation = 0
  
  override func loadView() {
    view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(imageView)
    addActions()
  }
  
  func addActions(){
    tap.addTarget(self, action: #selector(tapped), for: .touchUpInside)
  }
  
  /// cycle through animations each time the button is pressed
  // will add 1 to the value of currentAnimation unit it reaches 7 then back 0
  @objc func tapped(sender: UIButton){
    sender.isHidden = true
    
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {[unowned self] in
      switch self.currentAnimation{
        case 0:
          self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        case 1:
          self.imageView.transform = CGAffineTransform.identity
        case 2:
          self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
        case 3:
          self.imageView.transform = CGAffineTransform.identity
        case 4:
          self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        case 5:
          self.imageView.transform = CGAffineTransform.identity
        case 6:
          self.imageView.alpha = 0.1
          self.imageView.backgroundColor = UIColor.green
        case 7:
          self.imageView.alpha = 1
          self.imageView.backgroundColor = UIColor.clear
          break
        default:
          break
      }
    }){(finished: Bool) in
      sender.isHidden = false
    }
    
    currentAnimation += 1
    if currentAnimation > 7{
      currentAnimation = 0
    }
  }
}

