//
//  ViewController.swift
//  project32
//
//  Created by robert on 3/4/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

class ViewController: UITableViewController {
  private var projects = [(title: String, subtitle: String)]()
  private var favorites = [Int]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadFavorites()
    tableView.isEditing = true
    tableView.allowsSelectionDuringEditing = true
    projects.append(("Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"))
    projects.append(("Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"))
    projects.append(("Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"))
    projects.append(("Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"))
    projects.append(("Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"))
    projects.append(("Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"))
    projects.append(("Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"))
    projects.append(("Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."))
  }
  
  func loadFavorites(){
    let defaults = UserDefaults.standard
    if let favoritesFromUserDefaults = defaults.object(forKey: "favorites") as? [Int]{
      favorites = favoritesFromUserDefaults
    }
  }
  
  //MARK:- DATASOURCE
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let project = projects[indexPath.row]
    cell.textLabel?.attributedText = makeAtrributedString(project.title, project.subtitle)
    setAccessoryType(for: cell, at: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    if favorites.contains(indexPath.row) {
      return .delete
    } else {
      return .insert
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .insert {
      favorites.append(indexPath.row)
      index(item: indexPath.row)
    } else {
      if let index = favorites.index(of: indexPath.row) {
        favorites.remove(at: index)
        deindex(item: indexPath.row)
      }
    }
    
    let defaults = UserDefaults.standard
    defaults.set(favorites, forKey: "favorites")
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
  
  //MARK:- DELEGATE
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showTutorial(indexPath.row)
  }
  
  //MARK:- PRIVATE METHODS
  private func index(item: Int){
    let project = projects[item]
    
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
    attributeSet.title = project.title
    attributeSet.contentDescription = project.subtitle
    
    let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributeSet)
    item.expirationDate = Date.distantFuture
    CSSearchableIndex.default().indexSearchableItems([item]) { error in
      if let error = error {
        print("Indexing error: \(error.localizedDescription)")
      } else {
        print("Search item successfully indexed!")
      }
    }
  }
  
  private func deindex(item: Int){
    CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
      if let error = error {
        print("Deindexing error: \(error.localizedDescription)")
      } else {
        print("Search item successfully removed!")
      }
    }
  }
  
  private func setAccessoryType(for cell: UITableViewCell, at indexPath: IndexPath){
    if favorites.contains(indexPath.row) {
    cell.editingAccessoryType = .checkmark
    } else {
    cell.editingAccessoryType = .none
    }
  }
  
  private func attributeString(title: String) -> NSMutableAttributedString{
    let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
    let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
    return titleString
  }
  
  private func attrubuteString(subtitle: String) -> NSAttributedString{
    let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
    let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
    return subtitleString
  }
  
  private func makeAtrributedString(_ title: String,_  subTitle:String) -> NSAttributedString{
    let attributedString = attributeString(title: title)
    attributedString.append(attrubuteString(subtitle: subTitle))
    return attributedString
  }
  
  private func safariURLandConfiguration(_ which: Int) -> (url: URL, config: SFSafariViewController.Configuration)?{
    guard let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") else{
      return nil
    }
    let config = SFSafariViewController.Configuration()
    config.entersReaderIfAvailable = true
    return (url, config)
  }
  
  func showTutorial(_ which: Int) {
    guard let safariParams = safariURLandConfiguration(which) else{ return }
    let vc = SFSafariViewController(url: safariParams.url, configuration: safariParams.config)
    present(vc, animated: true)
  }
}
