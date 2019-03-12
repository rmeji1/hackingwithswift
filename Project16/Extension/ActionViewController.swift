//
//  ActionViewController.swift
//  Extension
//
//  Created by robert on 2/12/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
  @IBOutlet weak var script: UITextView!
  
  var pageTitle = ""{
    willSet{
      DispatchQueue.main.async { [unowned self] in
        self.title = newValue
      }
    }
  }
  var pageURL = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done
      , target: self, action: #selector(done))
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
      if let itemProvider = inputItem.attachments?.first {
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [unowned self] (dict, error) in
          let itemsDictionary = dict as! NSDictionary
          let javaScriptValues = itemsDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
          print(javaScriptValues)
          self.pageTitle = javaScriptValues.value(forKey: "title") as! String
          self.pageURL = javaScriptValues.value(forKey: "URL") as! String
        }
      }
    }
    
  }
  
  @objc func adjustForKeyboard(notification: Notification){
    let userInfo = notification.userInfo!
    
    let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      script.contentInset = UIEdgeInsets.zero
    } else {
      script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
    }
    
    script.scrollIndicatorInsets = script.contentInset
    
    let selectedRange = script.selectedRange
    script.scrollRangeToVisible(selectedRange)
  }
  
  @IBAction func done() {
    let item = NSExtensionItem()
    let argument: NSDictionary = ["customJavaScript": script.text]
    let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
    let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
    item.attachments = [customJavaScript]
    self.extensionContext!.completeRequest(returningItems: [item], completionHandler: nil)
  }
  
}
