//
//  View.swift
//  project13
//
//  Created by robert on 2/11/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class View: UIView {
  let placeHolderView : UIView = {
    var view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.gray
    return view
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = UIColor.white
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let intensityLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Intensity:"
    label.textAlignment = .right
    return label
  }()
  
  let slider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    return slider
  }()
  
  let changeFilterButton: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.roundedRect)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Change Filter", for: .normal)
    return button
  }()
  
  let saveButton: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.roundedRect)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Save", for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.white
    
    [placeHolderView, imageView, intensityLabel, slider, changeFilterButton, saveButton].forEach{
      addSubview($0)
    }
    
    activiateConstraints()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func activiateConstraints(){
    NSLayoutConstraint.activate(
      placeHolderViewConstraints() +
      imageViewConstraints() +
      intensityLabelConstraints() +
      sliderContraints() +
      changeFilterButtonConstraint() +
      saveButtonConstraints()
    )
  }
  
  func placeHolderViewConstraints() -> [NSLayoutConstraint]{
    return [
      placeHolderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      placeHolderView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
      placeHolderView.widthAnchor.constraint(equalTo: self.widthAnchor),
      placeHolderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -200.0)
//      placeHolderView.heightAnchor.constraint(equalToConstant: 540.0)
    ]
  }
  
  func imageViewConstraints() -> [NSLayoutConstraint]{
    let layoutguide = placeHolderView.layoutMarginsGuide
    return [
      imageView.topAnchor.constraint(equalTo: layoutguide.topAnchor, constant: 5),
      imageView.leftAnchor.constraint(equalTo: layoutguide.leftAnchor),
      imageView.widthAnchor.constraint(equalTo: layoutguide.widthAnchor),
      imageView.bottomAnchor.constraint(equalTo: layoutguide.bottomAnchor, constant: -5)
    ]
  }
  
  func intensityLabelConstraints() -> [NSLayoutConstraint]{
    return [
      intensityLabel.topAnchor.constraint(equalTo: placeHolderView.bottomAnchor, constant: 35.0),
      intensityLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
      intensityLabel.widthAnchor.constraint(equalToConstant: 72.0),
      intensityLabel.heightAnchor.constraint(equalToConstant: 21.0)
    ]
  }
  
  func sliderContraints() -> [NSLayoutConstraint]{
    return [
      slider.topAnchor.constraint(equalTo: intensityLabel.topAnchor),
      slider.leftAnchor.constraint(equalTo: intensityLabel.rightAnchor, constant: 16),
      slider.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
      slider.heightAnchor.constraint(equalTo: intensityLabel.heightAnchor)
    ]
  }
  
  func changeFilterButtonConstraint() -> [NSLayoutConstraint]{
    return [
      changeFilterButton.widthAnchor.constraint(equalToConstant: 120.0),
      changeFilterButton.heightAnchor.constraint(equalToConstant: 44.0),
      changeFilterButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 35.0),
      changeFilterButton.leadingAnchor.constraint(equalTo: intensityLabel.leadingAnchor)
    ]
  }
  
  func saveButtonConstraints() -> [NSLayoutConstraint]{
    return [
      saveButton.widthAnchor.constraint(equalToConstant: 60.0),
      saveButton.heightAnchor.constraint(equalToConstant: 44.0),
      saveButton.topAnchor.constraint(equalTo: changeFilterButton.topAnchor),
      saveButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
    ]
  }
}
