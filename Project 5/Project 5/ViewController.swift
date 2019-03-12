//
//  ViewController.swift
//  Project 5
//
//  Created by robert on 1/28/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var allWords = [String]()
  var usedWords = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let startWordsPath = Bundle.main.path(forResource:"start", ofType: "txt"){
      if let startWords = try? String(contentsOfFile: startWordsPath){
        allWords = startWords.components(separatedBy: "\n")
      }else{
        allWords = ["silkworm"]
      }
    }
    
    startGame()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
  }
  
  
  @objc func promptForAnswer(){
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
      let answer = ac.textFields![0]
      self.submit(answer: answer.text!)
    }
    
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  func submit(answer: String){
    let lowerAnswer = answer.lowercased()
      
      let errorTitle: String
      let errorMessage: String
      
      if isPossible(word: lowerAnswer) {
        if isOriginal(word: lowerAnswer) {
          if isReal(word: lowerAnswer) {
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            return
          } else {
            errorTitle = "Word not recognised"
            errorMessage = "You can't just make them up, you know!"
          }
        } else {
          errorTitle = "Word used already"
          errorMessage = "Be more original!"
        }
      } else {
        errorTitle = "Word not possible"
        errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
      }
      
      let alertViewController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
      alertViewController.addAction(UIAlertAction(title: "OK", style: .default))
      present(alertViewController, animated: true)
  }
  
  func startGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }
  
  func isPossible(word: String) -> Bool {
    var tempWord = title!.lowercased()
    
    for letter in word{
      // .range(of:) -> optional position of where the item was found
      if let position = tempWord.range(of: String(letter)){
        tempWord.remove(at: position.lowerBound)
      }else{
        return false
      }
    }
    return true
  }
  
  func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word)
  }
  
  func isReal(word: String) -> Bool {
    // UITextChecker -
    // An object you use to check a string (usually the text of a document)
    // for misspelled words.
    let checker = UITextChecker()
    // make a string range, which is a value that holds a start position and a length
    let range = NSMakeRange(0, word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }
}

