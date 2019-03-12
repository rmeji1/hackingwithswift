import UIKit


extension Int{
  mutating func plusOne() {
    self += 1
  }
  
  func squared() -> Int {
    return self * self
  }
}

// will be applied to all integer
// datatypes
extension BinaryInteger {
  func squared() -> Self {
    return self * self
  }
}

let i: Int = 8
print(i.squared())



