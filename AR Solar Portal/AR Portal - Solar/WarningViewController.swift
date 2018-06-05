//
//  WarningViewController.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 15/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {
   
   // MARK: - IBOutlets
   @IBOutlet weak var backgroundImageView: UIImageView!
   @IBOutlet weak var warningLabel: UILabel!
   
   // MARK: - View Controller Life Cycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Start background image animation
      rotateAnimation(imageView: backgroundImageView)
      
      // Setting warning text with localized
      warningLabel.text = "warning".localized
      
      // Show Warning Message 5 Second and Perform Segue to Main Screen
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
         self.performSegue(withIdentifier: "showMainScreen", sender: nil)
      }
   }
   
   
   //MARK: - Setting animation to background image
   func rotateAnimation(imageView: UIImageView, duration: CFTimeInterval = 10) {
      let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
      rotateAnimation.fromValue = 0.0
      rotateAnimation.toValue = CGFloat(.pi * 2.0)
      rotateAnimation.duration = duration
      rotateAnimation.repeatCount = Float.greatestFiniteMagnitude
      
      imageView.layer.add(rotateAnimation, forKey: nil)
   }
   
}



extension String {
   var localized: String {
      return NSLocalizedString(self, tableName: "Localizable", value: "**\(self)**", comment: "")
   }
}

