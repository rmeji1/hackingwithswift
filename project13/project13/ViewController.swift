//
//  ViewController.swift
//  project13
//
//  Created by robert on 2/11/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
  //TODO: NEED TO ADD NSPhotoLibaryAddUsageDescription key to info.plist
  
  //MARK: Outlets
  unowned var imageView: UIImageView { return (view as! View).imageView }
  unowned var intensitySlider: UISlider{ return (view as! View).slider }
  
  var currentImage: UIImage!
  var context: CIContext! // handles coreimage renderings
  var currentFilter: CIFilter!
  var filterList = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate","CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]
  
  override func loadView() {
    view = View()
    (view as! View).changeFilterButton.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
    (view as! View).saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    (view as! View).slider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "YACIFP"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    
    // coreimage items
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
  }
  
  @objc func changeFilter(sender: UIButton){
    let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
    filterList.forEach{
      ac.addAction(UIAlertAction(title: $0, style: .default, handler: setFilter))
    }
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    // in iphone the next two lines don't mean anything.
    ac.popoverPresentationController?.permittedArrowDirections = .down
    ac.popoverPresentationController?.sourceView = sender
    present(ac, animated: true)
  }
  
  @objc func save(sender: UIButton){
    UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  @objc func intensityChanged(sender: UISlider){
    applyProcessing()
  }
  
  @objc func importPicture(){
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true)
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      // we got back an error!
      let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
  
  func setFilter(action: UIAlertAction){
    guard currentImage != nil else { return }
    
    let beginImage = CIImage(image: currentImage)
    currentFilter = CIFilter(name: action.title!)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    
    applyProcessing()
  }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    currentImage = image
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }
  
  private func applyProcessing(){
    let inputKeys = currentFilter.inputKeys
    
    if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey) }
    if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey) }
    if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey) }
    if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
    
    if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
      let processedImage = UIImage(cgImage: cgimg)
      self.imageView.image = processedImage
    }
  }
}
