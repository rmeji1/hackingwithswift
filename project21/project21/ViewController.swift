//
//  ViewController.swift
//  project21
//
//  Created by robert on 2/14/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
  }
  
  /// request permissions to send local notifications to our users
  @objc func registerLocal(){
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert,.badge,.sound]){ (granted, error) in
      if granted{
        print("yay")
      }else{
        print("d'oh")
      }
    }
  }

  @objc func scheduleLocal(){
    let center = UNUserNotificationCenter.current()
    registerCategories()
 /// 3 items needed trigger, content, request
//    let trigger = createTrigger()
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let content = createContent()
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    center.add(request)
  }
  
  func registerCategories(){
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
    let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
    
    center.setNotificationCategories([category])
  }
  
  func createTrigger() -> UNNotificationTrigger{
    // since no day is specified it means 10:30 tomorrow or 10:30 everyday
    // depending on whether the notificaiotn is repeated
    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
  }
  
  func createContent() -> UNMutableNotificationContent{
    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default
    return content
  }

  func createContentExample() -> UNMutableNotificationContent{
    let content = UNMutableNotificationContent() // has many properties
    content.title = "Title goes here" // main title of alert
    content.body = "Main text goes here" // main text
    content.categoryIdentifier = "customIdentifier" // custom actions can be added by spec this
    content.userInfo = ["customData":"fizzbuzz"] // used to attached custom data
    content.sound = UNNotificationSound.default // can create a custom sound but don't here
    return content
  }

}

extension ViewController: UNUserNotificationCenterDelegate{
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // pull out the buried userInfo dictionary
    let userInfo = response.notification.request.content.userInfo
    
    if let customData = userInfo["customData"] as? String {
      print("Custom data received: \(customData)")
      
      switch response.actionIdentifier {
      case UNNotificationDefaultActionIdentifier:
        // the user swiped to unlock
        print("Default identifier")
        
      case "show":
        // the user tapped our "show more info…" button
        print("Show more information…")
        
      default:
        break
      }
    }
    
    // you must call the completion handler when you're done
    completionHandler()
  } }
