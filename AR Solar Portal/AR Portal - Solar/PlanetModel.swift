//
//  PlanetModel.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 24/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import Foundation

struct PLANETS {
   
   // 태양
   struct SUN {
      static let diffuse = "sun"
      static let emission = "sun-halo"
      static let radius = 0.5
      static let rotating = 25.0
      static let inclination = 0
   }
   
   // 수성
   struct MERCURY {
      static let diffuse = "mercury"
      static let radius = 0.04
      static let AU = 0.2
      static let rotating = 50.0
      static let revolution = 88.0
      static let inclination = 0
   }
   
   // 금성
   struct VENUS {
      static let diffuse = "venus_surface"
      static let emission = "venus_atmosphere"
      static let radius = 0.06
      static let AU = 0.4
      static let rotating = 100.0
      static let revolution = 224.0
      static let inclination = 3
   }
   
   // 지구
   struct EARTH {
      static let diffuse = "earth_daymap"
      static let specular = "earth_specular_map"
      static let emission = "earth_clouds"
      static let normal = "earth_normal_map"
      static let radius = 0.08
      static let AU = 0.6
      static let rotating = 10.0
      static let revolution = 365.0
      static let inclination = 23
   }
   
   // 화성
   struct MARS {
      static let diffuse = "mars"
      static let radius = 0.04
      static let AU = 0.8
      static let rotating = 10.0
      static let revolution = 300.0
      static let inclination = 25
   }
   
   // 목성
   struct JUPITER {
      static let diffuse = "jupiter"
      static let radius = 0.3
      static let AU = 1.3
      static let rotating = 5.0
      static let revolution = 600.0
      static let inclination = 3
   }
   
   // 토성
   struct SATURN {
      static let diffuse = "saturn"
      static let radius = 0.2
      static let AU = 2.0
      static let rotating = 5.0
      static let revolution = 800.0
      static let inclination = 27
   }
   
   // 천왕성
   struct URANUS {
      static let diffuse = "uranus"
      static let radius = 0.1
      static let AU = 2.5
      static let rotating = 4.0
      static let revolution = 700.0
      static let inclination = 97
   }
   
   // 해왕성
   struct NEPTUNE {
      static  let diffuse = "neptune"
      static let radius = 0.1
      static let AU = 2.8
      static let rotating = 4.0
      static let revolution = 900.0
      static let inclination = 28
   }
   
   // 달
   struct MOON {
      static let diffuse = "moon"
      static let radius = 0.001
      static let AU = 0.03
      static let rotating = 58.0
      static let revolution = 88.0
      static let inclination = 0
   }
}

