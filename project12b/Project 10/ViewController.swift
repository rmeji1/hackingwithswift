//
//  ViewController.swift
//  Project 10
//
//  Created by robert on 2/7/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
  var people = [Person]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    
    if let savedPeople = UserDefaults.standard.object(forKey: "people") as? Data{
      do{
        people = try JSONDecoder().decode([Person].self, from: savedPeople)
      }catch{
        print("Failed to load people")
      }
    }
  }
  
  @objc func addNewPerson(){
    let pickerVC = UIImagePickerController()
    pickerVC.delegate = self
    pickerVC.allowsEditing = true
    present(pickerVC, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCollectionViewCell
    let person = people[indexPath.item]
    cell.name.text = person.name
    let path = getDocumentsDirectory().appendingPathComponent(person.image)
    cell.imageView.image = UIImage(contentsOfFile: path.path)
    
    cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]
    let alertController = UIAlertController(title: "Enter Name", message: "Please enter the users name", preferredStyle: .alert)
    alertController.addTextField()
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.addAction(UIAlertAction(title: "OK", style: .default){[unowned self, alertController] _ in
      let newName = alertController.textFields![0]
      person.name = newName.text!
      self.collectionView?.reloadData()
      self.save()
    })
    present(alertController, animated: true)
  }
  
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
    
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let person = Person(name: "Unknown", image: imageName)
    people.append(person)
    collectionView?.reloadData()
    save()
    dismiss(animated: true)
  }
  
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  private func save(){
    let jsonEncoder = JSONEncoder()
    if let saveData = try? jsonEncoder.encode(people){
      let defaults = UserDefaults.standard
      defaults.set(saveData, forKey:"people")
    }else{
      print("Failed to save people")
    }
  }
}
