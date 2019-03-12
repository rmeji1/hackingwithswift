//
//  InterfaceController.swift
//  Project37 WatchKit Extension
//
//  Created by robert on 3/6/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
  @IBOutlet weak var welcomeText: WKInterfaceLabel!
  
  @IBOutlet weak var hideButton: WKInterfaceButton!
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
    if WCSession.isSupported(){
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  @IBAction func hideWelcomeText() {
    [welcomeText, hideButton].forEach({
      $0.setHidden(true)
    })
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
}

extension InterfaceController: WCSessionDelegate{
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    WKInterfaceDevice().play(.click)
  }
  
}
