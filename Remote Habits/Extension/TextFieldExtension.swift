//
//  TextFieldExtension.swift
//  Remote Habits
//
//  Created by Amandeep Kaur on 09/12/21.
//

import Foundation
import UIKit

extension UITextField {
    
  var trimTextWithWhiteSpaces: Bool {
      return self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "" == ""
  }
}
