//
//  ViewController.swift
//  Project2
//
//  Created by robert on 12/27/18.
//  Copyright © 2018 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  //MARK: - SUBVIEW DECLARATIONS
  let buttonOne : UIButton = {
    return UIButton(type: .custom, height: 200, width: 100)
  }()
  
  let buttonTwo : UIButton = {
    return UIButton(type: .custom, height: 200, width: 100)
  }()
  
  let buttonThree : UIButton = {
    return UIButton(type: .custom, height: 200, width: 100)
  }()
  
  // MARK: - Properties
  var countries = [String]()
  var correctAnswer = 0
  var score = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    title = "Guess the Flag"
    // Do any additional setup after loading the view, typically from a nib.
    addSubviews()
    setConstraints()
    addTagsToButtons()
    addTargets()
    askQuestion()
  }
  
  func addTagsToButtons(){
    buttonOne.tag = 0
    buttonTwo.tag = 1
    buttonThree.tag = 2
  }
  
  func addSubviews(){
    [buttonOne, buttonTwo, buttonThree].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  func setConstraints(){
    let margins = view.layoutMarginsGuide
    let centerXAnchor = margins.centerXAnchor
    
    buttonOne.topAnchor.constraint(equalTo: margins.topAnchor, constant: 36.0).isActive = true
    buttonOne.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    buttonTwo.topAnchor.constraint(equalTo: buttonOne.bottomAnchor, constant: 30.0).isActive = true
    buttonTwo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    buttonThree.topAnchor.constraint(equalTo: buttonTwo.bottomAnchor, constant: 30.0).isActive = true
    buttonThree.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    buttonThree.bottomAnchor.constraint(greaterThanOrEqualTo: margins.bottomAnchor, constant: 20.0).isActive = true

    
  }
  
  func addTargets(){
    buttonOne.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    buttonTwo.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    buttonThree.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    title = countries[correctAnswer].uppercased()
    buttonOne.setImage(UIImage(named: countries[0]), for: .normal)
    buttonTwo.setImage(UIImage(named: countries[1]), for: .normal)
    buttonThree.setImage(UIImage(named: countries[2]), for: .normal)
  }
  
  // MARK: - ACTIONS
  @objc func buttonTapped(_ sender: UIButton){
    print("Button tapped")
    
    var title: String
    
    if sender.tag == correctAnswer {
      title = "Correct"
      score += 1
    } else {
      title = "Wrong"
      score -= 1
    }
    
    
    let actionController = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
    actionController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
    present(actionController, animated: true)
  }
}
