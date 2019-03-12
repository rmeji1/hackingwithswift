//
//  ViewController.swift
//  Project1
//
//  Created by robert on 12/21/18.
//  Copyright © 2018 Mejia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

  let cellIdentifer = "picture"
  var pictures = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
//    tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellIdentifer)
    
    // Do any additional setup after loading the view, typically from a nib.
    let path = Bundle.main.resourcePath!
    let items = try! FileManager.default.contentsOfDirectory(atPath: path)
    items.forEach{
      if $0.hasPrefix("nssl"){
        pictures.append("\(path)/\($0)")
        print("\(path)/\($0)")
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifer)
    cell.textLabel?.text = pictures[indexPath.row]
    cell.imageView?.image = UIImage(contentsOfFile: pictures[indexPath.row])
    cell.imageView?.sizeToFit()
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = DetailViewController(with: pictures[indexPath.row])
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
}
