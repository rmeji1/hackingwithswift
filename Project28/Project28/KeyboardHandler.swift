//
//  KeyboardHandler.swift
//  Project28
//
//  Created by robert on 2/26/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

class KeyboardHandler: NSObject{
  weak var scrollView: UIScrollView!
  weak var view: UIView!
  
  init(scrollView: UIScrollView, view: UIView) {
    self.scrollView = scrollView
    self.view = view
  }
  
   func addObserver(){
    let notificationCenter = NotificationCenter.default
    let keyboardAction = #selector(adjustForKeyboard)
    notificationCenter.addObserver(self, selector: keyboardAction,
                                   name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    notificationCenter.addObserver(self, selector: keyboardAction,
                                   name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func adjustForKeyboard(notification: Notification){
    let userInfo = notification.userInfo!
    // UIResponder.keyboardFrameEndUserInfoKey
    // pulls out the correct frame of the keyboard
    //    1
    let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    // need to convert the retangle from step 1 to our view specifications
    //    2
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    //    adjust contentInset and scroll insets so that its algined with top
    // of the keyboard
    // conentInset lets you change height or width of view from its constraints
    //    3
    if notification.name == UIResponder.keyboardWillHideNotification {
      scrollView.contentInset = UIEdgeInsets.zero
    } else {
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
    }
    
    scrollView.scrollIndicatorInsets = scrollView.contentInset
    
    // 4 this scrolls to where the cursor is
    if let textView = scrollView as? UITextView{
      let selectedRange = textView.selectedRange
      textView.scrollRangeToVisible(selectedRange)
    }
  }
}
