//
//  ViewController.swift
//  Project27
//
//  Created by robert on 2/21/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  let button: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.roundedRect)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Switch", for: .normal)
    button.backgroundColor = .white
    return button
  }()
  
  var currentDrawType = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    [imageView, button].forEach{ view.addSubview($0)}
    button.addTarget(self, action: #selector(redrawTapped), for: .touchUpInside)
    activateConstraints()
    drawRectangle()
  }


  @objc func redrawTapped(sender: UIButton) {
    currentDrawType += 1
    
    if currentDrawType > 5{
      currentDrawType = 0
    }
    
    switch currentDrawType {
    case 0:
      drawRectangle()
    case 1:
      drawCircle()
    case 2:
      drawCheckerBoard()
    case 3:
      drawRotatedSquares()
    case 4:
      drawLines()
    case 5:
      drawImagesAndText()
    default:
      break
    }
  }
  
  func drawImagesAndText(){
    // 1
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 365, height: 365))
    
    let img = renderer.image { ctx in
      // 2
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      // 3
      let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
      
      // 4
      let string = "The best-laid schemes o'\nmice an' men gang aft agley"
      string.draw(with: CGRect(x: 32, y: 32, width: 330, height: 330), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
      
      // 5
      let mouse = UIImage(named: "mouse")
      mouse?.draw(at: CGPoint(x: 300, y: 150))
    }
    
    // 6
    imageView.image = img
  }
  
  func drawRotatedSquares() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 365, height: 365))
    
    let img = renderer.image { ctx in
      ctx.cgContext.translateBy(x: 365 / 2, y: 365 / 2)
      
      let rotations = 16
      let amount = Double.pi / Double(rotations)

      for _ in 0 ..< rotations {
        ctx.cgContext.rotate(by: CGFloat(amount))
        ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
      }
      
      ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
      ctx.cgContext.strokePath()
    }
    
    imageView.image = img
  }
  
  func drawCheckerBoard(){
    let render = UIGraphicsImageRenderer(size: CGSize(width: 365, height: 365))
    
    let img = render.image{ ctx in
      ctx.cgContext.setFillColor(UIColor.black.cgColor)
      
      for row in 0 ..< 8 {
        for col in 0 ..< 8 {
          if (row + col) % 2 == 0 {
            ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
          }
        }
      }
    }
    imageView.image = img
  }
  
  func drawCircle(){
    let render = UIGraphicsImageRenderer(size: CGSize(width: 365, height: 365))
    
    let img = render.image{ ctx in
      let rectangle = CGRect(x: 5, y: 5, width: 355, height: 355)
      
      ctx.cgContext.setFillColor(UIColor.red.cgColor)
      ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
      ctx.cgContext.setLineWidth(10)
      
      ctx.cgContext.addEllipse(in: rectangle)
      ctx.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
  
  func drawRectangle()  {
    let render = UIGraphicsImageRenderer(size: CGSize(width: 365, height: 365))
    
    let img = render.image{ ctx in
      let rectangle = CGRect(x: 0, y: 0, width: 365, height: 365)
      
      ctx.cgContext.setFillColor(UIColor.red.cgColor)
      ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
      ctx.cgContext.setLineWidth(10)
      
      ctx.cgContext.addRect(rectangle)
      ctx.cgContext.drawPath(using: .fillStroke)
    }
    
    imageView.image = img
  }
  
  func drawLines() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 365, height: 365))
    
    let img = renderer.image { ctx in
      ctx.cgContext.translateBy(x: 365 / 2, y: 365 / 2)
      
      var first = true
      var length: CGFloat = 365 / 2
      
      for _ in 0 ..< 256 {
        ctx.cgContext.rotate(by: CGFloat.pi / 2)
        
        if first {
          ctx.cgContext.move(to: CGPoint(x: length, y: 50))
          first = false
        } else {
          ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
        }
        
        length *= 0.99
      }
      
      ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
      ctx.cgContext.strokePath()
    }
    
    imageView.image = img
  }
  
  fileprivate func activateConstraints() {
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
      button.heightAnchor.constraint(equalToConstant: 50),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
  }
}

