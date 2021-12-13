//
//  RHCustomisedTableView.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 01/12/21.
//

import Foundation
import UIKit

class RHCustomisedTableView : UITableView {
    override var adjustedContentInset: UIEdgeInsets {
         if self.frame.height > contentSize.height  {
              let heightBottom =
                  ( self.frame.height - contentSize.height ) + 0.5
            return UIEdgeInsets(
                   top: self.contentInset.top + 0.5 ,
                   left: self.contentInset.left ,
                   bottom: heightBottom ,
                  right: self.contentInset.right )
         }
      return UIEdgeInsets(
             top: self.contentInset.top + 0.5 ,
             left: self.contentInset.left ,
             bottom: self.contentInset.right ,
            right: self.contentInset.right )
    }
}
