//
//  Int-TimeFormatting.swift
//  FriendZone
//
//  Created by robert on 1/28/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import Foundation

extension Int{
  func timeString() -> String{
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour,.minute]
    formatter.unitsStyle = .positional
    
    let formattedString = formatter.string(from: TimeInterval(self)) ?? "0"
    
    if formattedString == "0"{
      return "GMT"
    }else{
      if formattedString.hasPrefix("-"){
        return "GMT\(formattedString)"
      }else{
        return "GMT+\(formattedString)"
      }
    }
  }
}
