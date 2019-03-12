//
//  ViewController.swift
//  Project8
//
//  Created by robert on 2/7/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var cluesLabel: UILabel!
  @IBOutlet weak var answersLabel: UILabel!
  
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var currentAnswer: UITextField!
  
  var letterButtons = [UIButton]()
  var activeButtons = [UIButton]()
  var solutions = [String]()
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  var level = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for subview in view.subviews where subview.tag == 1{ // get parent stack view
      for sub in subview.subviews{ // for child subview which is a stack view
        for btn in sub.subviews{
          let button = btn as! UIButton
          letterButtons.append(button)
          button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
          print(letterButtons.count)
        }
      }
    }
    
    loadLevel()
  }
  
  @objc func letterTapped(btn: UIButton){
    currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
    activeButtons.append(btn)
    btn.isHidden = true
  }

  @IBAction func submitTapped(_ sender: Any) {
    
    if let solutionPosition = solutions.index(of: currentAnswer.text!) {
      activeButtons.removeAll()
      
      var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
      splitAnswers[solutionPosition] = currentAnswer.text!
      answersLabel.text = splitAnswers.joined(separator: "\n")
      
      currentAnswer.text = ""
      score += 1
      
      if score % 7 == 0 {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
    }
    
  }
  
  func levelUp(action: UIAlertAction) {
    level += 1
    solutions.removeAll(keepingCapacity: true)
    
    loadLevel()
    
    for btn in letterButtons {
      btn.isHidden = false
    }
  }
  
  @IBAction func clearTapped(_ sender: Any) {
    currentAnswer.text = ""
    
    for btn in activeButtons {
      btn.isHidden = false
    }
    
    activeButtons.removeAll()
  }
  
  func loadLevel(){
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt"){
      if let levelContents = try? String(contentsOfFile: levelFilePath){
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()
        
        for (index, line) in lines.enumerated(){
          let parts = line.components(separatedBy: ": ")
          let answer = parts[0]
          let clue = parts[1]
          
          clueString += "\(index + 1). \(clue)\n"
          
          let solutionWord = answer.replacingOccurrences(of: "|", with: "")
          solutionString += "\(solutionWord.count) letters\n"
          solutions.append(solutionWord)
          
          let bits = answer.components(separatedBy: "|")
          letterBits += bits
        }
      }
    }
    // Now configure the buttons and labels
    cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
    answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    letterBits.shuffle()
    
    if letterBits.count == letterButtons.count {
      for i in 0 ..< letterButtons.count {
        letterButtons[i].setTitle(letterBits[i], for: .normal)
      }
    }
//    errorAlert("Loading level")
  }
  
  private func errorAlert(_ message: String){
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title:"ok", style:.default))
    present(alertController, animated: false)
  }
}

