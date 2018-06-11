//
//  Utilities.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 2018. 6. 11..
//  Copyright © 2018년 Seo Jaehyeong. All rights reserved.
//

import Foundation

extension String {
   var localized: String {
      return NSLocalizedString(self, tableName: "Localizable", value: "**\(self)**", comment: "")
   }
}


extension Int {
   var degreesToRadians: Double { return Double(self) * .pi/180}
}
