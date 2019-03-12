//
//  DetailViewController.swift
//  Project1
//
//  Created by robert on 12/24/18.
//  Copyright © 2018 Mejia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  let imageView : UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  var selectedImage: String?
  
  init(with fileName: String){
    selectedImage = fileName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Image Viewer"
    navigationItem.largeTitleDisplayMode = .never
    // Got an error here becuse I didn't add the subviews to the main view
    [imageView].forEach{
      view.addSubview($0)
    }
    // need x,y, width, height constraints
    imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
    if let selectedImage = selectedImage{
      imageView.image = UIImage(contentsOfFile: selectedImage)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    // must disable because it will stay active in other views
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
