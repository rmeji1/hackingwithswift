//
//  ViewController.swift
//  Project7
//
//  Created by robert on 2/6/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{
  var petitions = [Petition]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let urlString : String
    if navigationController?.tabBarItem.tag == 0 {
      urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    }else{
      urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
    }
    // this is a bad idea because you are locking up data in view did load.
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        parse(json: data)
        return
      }
    }
    
    showError()
  }
  
  func showError(){
    let alertcontroller = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
    alertcontroller.addAction(UIAlertAction(title: "Ok", style: .default))
    present(alertcontroller, animated: true)
  }
  
  func parse(json: Data) {
    let decoder = JSONDecoder()
    
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return petitions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = petitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailViewController()
    vc.detailItem = petitions[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
}

