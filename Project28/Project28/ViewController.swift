//
//  ViewController.swift
//  Project28
//
//  Created by robert on 2/22/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
  unowned var viewAsView : View { return view as! View }
  unowned var secret: UITextView { return viewAsView.textView }
  private var keyboardHandler: KeyboardHandler!
  private let keychainKey = "SecretMessage"
  
  override func loadView() {
    self.view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Nothing to see here"
    let buttonAction = #selector(authenticateTapped)
    viewAsView.button.addTarget(self, action: buttonAction, for: .touchUpInside)
    keyboardHandler = KeyboardHandler(scrollView: secret, view: view)
    keyboardHandler.addObserver()
    
    let notificaionCenter = NotificationCenter.default
    notificaionCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
  }
  
  //  Touch ID and Face ID are part of the Local Authentication framework, and our code needs to three things:
  //
  //  Check whether the device is capable of supporting biometric authentication.
  //  If so, request that the biometry system begin a check now, giving it a string containing the reason why we're asking. For Touch ID the string is written in code; for Face ID the string is written into our Info.plist file.
  //  If we get success back from the authentication request it means this is the device's owner so we can unlock the app, otherwise we show a failure message.
  @objc func authenticateTapped(sender: UIButton){
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
      let reason = "Identify yourself!" // message works for touch id
      // for faceId need to set Privacy - Face Id Usage Description in info
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
        [unowned self] (sucess, authenticationError) in
        // authorization may return in background thread therefore need to bring
        // back to main thread
        DispatchQueue.main.async {
          if sucess {
            self.unlockSecretMessage()
          }else{
            let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)
          }
        }
      }
    }else{
      let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default))
      present(ac, animated: true)
    }
  }
  // show textview then load teh keychains text into it
  private func unlockSecretMessage(){
    secret.isHidden = false
    title = "Secret Stuff!"
    
    if let text = KeychainWrapper.standard.string(forKey: keychainKey){
      secret.text = text
    }
  }
  
  // write textview stuff into keychain then hide textview
  @objc private func saveSecretMessage(){
    if !secret.isHidden{
      _ = KeychainWrapper.standard.set(secret.text, forKey: keychainKey)
      secret.resignFirstResponder()
      secret.isHidden = true
      title = "Nothing to see here"
    }
  }
}

