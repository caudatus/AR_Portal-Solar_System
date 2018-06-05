//
//  PlanetLoader.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 16/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import Foundation
import ARKit

class PlanetLoader {

   var loadedPlanetIndex: Set<Int> = []
   
   var basicPosition = SCNVector3(0, 0, -1)
   
   
   func planet(radius: CGFloat, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, time: TimeInterval, position: SCNVector3, inclination: Int) -> SCNNode {
      
      let planet = SCNNode(geometry: SCNSphere(radius: radius))
      planet.geometry?.firstMaterial?.diffuse.contents = diffuse
      planet.geometry?.firstMaterial?.specular.contents = specular
      planet.geometry?.firstMaterial?.emission.contents = emission
      planet.geometry?.firstMaterial?.normal.contents = normal
      planet.position = position
      planet.eulerAngles = SCNVector3(0, 0, inclination.degreesToRadians)
      
//      let lightNode = SCNNode()
//      lightNode.light = SCNLight()
//      lightNode.light?.color = UIColor.white // initially switched off
//      lightNode.light?.type = .omni
//      planet.addChildNode(lightNode)
      
      let planetRotation = rotation(time: time)
      planet.runAction(planetRotation)
      
      return planet
   }
   
   
   func planetWithRing(radius: CGFloat, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, time: TimeInterval, position: SCNVector3, inclination: Int) -> SCNNode {
      
      let planetParent = SCNNode()
      planetParent.position = position
      planetParent.eulerAngles = SCNVector3(0, 0, inclination.degreesToRadians)
      
      let planet = SCNNode(geometry: SCNSphere(radius: radius))
      planet.geometry?.firstMaterial?.diffuse.contents = diffuse
      planet.geometry?.firstMaterial?.specular.contents = specular
      planet.geometry?.firstMaterial?.emission.contents = emission
      planet.geometry?.firstMaterial?.normal.contents = normal
      planet.renderingOrder = 500
      
      let planetRotation = rotation(time: time)
      planet.runAction(planetRotation)
      
      let planetRing = SCNNode(geometry: SCNBox(width: 1.0, height: 0.0001, length: 1.0, chamferRadius: 0))
      planetRing.opacity = 0.9
      //planetRing.geometry?.firstMaterial?.isDoubleSided = true
      planetRing.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "saturn_loop")
      planetRing.geometry?.firstMaterial?.lightingModel = .constant
      planetRing.renderingOrder = 510
      
      planetParent.addChildNode(planet)
      planetParent.addChildNode(planetRing)
      
      return planetParent
   }
   
   
   func loadPlanet(with name: String, anchor: ARPlaneAnchor) -> SCNNode {
      
      let planeXposition = anchor.transform.columns.3.x
      //let planeYposition = anchor.transform.columns.3.y
      let planeZposition = anchor.transform.columns.3.z
      let planetPosition =  SCNVector3(planeXposition, 0, planeZposition)
      
      switch name {
      case "SUN":
         return planet(radius: 0.2,
                diffuse: UIImage(named: PLANETS.SUN.diffuse)!,
                specular: nil,
                emission: nil,
                normal: nil,
                time: 30,
                position: planetPosition,
                inclination: PLANETS.SUN.inclination)
      case "MERCURY":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.MERCURY.diffuse)!,
                       specular: nil,
                       emission: nil,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.MERCURY.inclination)
      case "VENUS":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.VENUS.diffuse)!,
                       specular: nil,
                       emission: UIImage(named: PLANETS.VENUS.emission)!,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.VENUS.inclination)
      case "EARTH":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.EARTH.diffuse)!,
                       specular: UIImage(named: PLANETS.EARTH.specular)!,
                       emission: UIImage(named: PLANETS.EARTH.emission)!,
                       normal: UIImage(named: PLANETS.EARTH.normal)!,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.EARTH.inclination)
      case "MARS":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.MARS.diffuse)!,
                       specular: nil,
                       emission: nil,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.MARS.inclination)
      case "JUPITER":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.JUPITER.diffuse)!,
                       specular: nil,
                       emission: nil,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.JUPITER.inclination)
      case "SATURN":
         return planetWithRing(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.SATURN.diffuse)!,
                       specular: nil,
                       emission: nil,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.SATURN.inclination)
      case "URANUS":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.URANUS.diffuse)!,
                       specular: nil,
                       emission: nil,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.URANUS.inclination)
      case "NEPTUNE":
         return planet(radius: 0.2,
                       diffuse: UIImage(named: PLANETS.NEPTUNE.diffuse)!,
                       specular: nil,
                       emission: nil,
                       normal: nil,
                       time: 30,
                       position: planetPosition,
                       inclination: PLANETS.NEPTUNE.inclination)
      default:
         fatalError("you try to make a not existing planet")
      }
      
      return SCNNode()
   }
   
   
   func makeOrbit(position: Double) -> SCNNode {
      let node = SCNNode(geometry: SCNTube(
         innerRadius: CGFloat(position),
         outerRadius: CGFloat(position + 0.001),
         height: 0.001))
      
      return node
   }
   
   
   func loadPlanetSolarSystem() -> SCNNode {
      
      let basicHeight: Float = 0.8
      
      let sun = SCNNode(geometry: SCNSphere(radius: 0.1))
      sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")
      sun.position = SCNVector3(0, basicHeight, 0)
      sun.renderingOrder = 200
      
      let parentNode = SCNNode()
      parentNode.position = SCNVector3(0, 0, -5)
      parentNode.addChildNode(sun)
      
      let mercuryParent = SCNNode()
      mercuryParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(mercuryParent)
      
      let venusParent = SCNNode()
      venusParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(venusParent)
      
      let earthParent = SCNNode()
      earthParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(earthParent)
      
      let moonParent = SCNNode()
      moonParent.position = SCNVector3(1.2, basicHeight, 0)
      earthParent.addChildNode(moonParent)
      
      let marsParent = SCNNode()
      marsParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(marsParent)
      
      let jupiterParent = SCNNode()
      jupiterParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(jupiterParent)
      
      let saturnParent = SCNNode()
      saturnParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(saturnParent)
      
      let uranusParent = SCNNode()
      uranusParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(uranusParent)
      
      let neptuneParent = SCNNode()
      neptuneParent.position = SCNVector3(0, basicHeight, 0)
      parentNode.addChildNode(neptuneParent)
      
      //Planet
      let mercury = planet(radius: CGFloat(PLANETS.MERCURY.radius),
                           diffuse: UIImage(named: PLANETS.MERCURY.diffuse)!,
                           specular: nil,
                           emission: nil,
                           normal: nil,
                           time: PLANETS.MERCURY.rotating,
                           position: SCNVector3(0, 0, -PLANETS.MERCURY.AU),
                           inclination: PLANETS.MERCURY.inclination)
      mercury.renderingOrder = 210
      mercury.geometry?.firstMaterial?.lightingModel = .constant
      mercuryParent.addChildNode(mercury)
      
      let mercuryOrbit = makeOrbit(position: PLANETS.MERCURY.AU)
      mercuryOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      mercuryOrbit.opacity = 0.4
      mercuryOrbit.renderingOrder = 220
      mercuryParent.addChildNode(mercuryOrbit)

      let venus = planet(radius: CGFloat(PLANETS.VENUS.radius),
                         diffuse: UIImage(named: PLANETS.VENUS.diffuse)!,
                         specular: nil,
                         emission: UIImage(named: PLANETS.VENUS.emission)!,
                         normal: nil,
                         time: PLANETS.VENUS.rotating,
                         position: SCNVector3(0, 0, PLANETS.VENUS.AU),
                         inclination: PLANETS.VENUS.inclination)
      venus.renderingOrder = 230
      venus.geometry?.firstMaterial?.lightingModel = .constant
      venusParent.addChildNode(venus)
      
      let venusOrbit = makeOrbit(position: PLANETS.VENUS.AU)
      venusOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      venusOrbit.opacity = 0.4
      venusOrbit.renderingOrder = 240
      venusParent.addChildNode(venusOrbit)

      let earth = planet(radius: CGFloat(PLANETS.EARTH.radius),
                         diffuse: UIImage(named: PLANETS.EARTH.diffuse)!,
                         specular: UIImage(named: PLANETS.EARTH.specular)!,
                         emission: UIImage(named: PLANETS.EARTH.emission)!,
                         normal: UIImage(named: PLANETS.EARTH.normal)!,
                         time: PLANETS.EARTH.rotating,
                         position: SCNVector3(PLANETS.EARTH.AU, 0, 0),
                         inclination: PLANETS.EARTH.inclination)
      earth.renderingOrder = 250
      earth.geometry?.firstMaterial?.lightingModel = .constant
      earthParent.addChildNode(earth)
      
      let earthOrbit = makeOrbit(position: PLANETS.EARTH.AU)
      earthOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      earthOrbit.opacity = 0.4
      earthOrbit.renderingOrder = 260
      earthParent.addChildNode(earthOrbit)

//      let moon = planet(radius: 0.05,
//                        diffuse: UIImage(named: "moon")!,
//                        specular: nil,
//                        emission: nil,
//                        normal: nil,
//                        time: 0,
//                        position: SCNVector3(0, 0, -1))
//      moonParent.addChildNode(moon)

      let mars = planet(radius: CGFloat(PLANETS.MARS.radius),
                        diffuse: UIImage(named: PLANETS.MARS.diffuse)!,
                        specular: nil,
                        emission: nil,
                        normal: nil,
                        time: PLANETS.MARS.rotating,
                        position: SCNVector3(0, 0, -PLANETS.MARS.AU),
                        inclination: PLANETS.MARS.inclination)
      mars.renderingOrder = 270
      mars.geometry?.firstMaterial?.lightingModel = .constant
      marsParent.addChildNode(mars)
      
      let marsOrbit = makeOrbit(position: PLANETS.MARS.AU)
      marsOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      marsOrbit.opacity = 0.4
      marsOrbit.renderingOrder = 280
      marsParent.addChildNode(marsOrbit)

      let jupiter = planet(radius: CGFloat(PLANETS.JUPITER.radius),
                           diffuse: UIImage(named: PLANETS.JUPITER.diffuse)!,
                           specular: nil,
                           emission: nil,
                           normal: nil,
                           time: PLANETS.JUPITER.rotating,
                           position: SCNVector3(-PLANETS.JUPITER.AU, 0, 0),
                           inclination: PLANETS.JUPITER.inclination)
      jupiter.renderingOrder = 290
      jupiter.geometry?.firstMaterial?.lightingModel = .constant
      jupiterParent.addChildNode(jupiter)
      
      let jupiterOrbit = makeOrbit(position: PLANETS.JUPITER.AU)
      jupiterOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      jupiterOrbit.opacity = 0.4
      jupiterOrbit.renderingOrder = 300
      jupiterParent.addChildNode(jupiterOrbit)

      let saturn = planetWithRing(radius: CGFloat(PLANETS.SATURN.radius),
                          diffuse: UIImage(named: PLANETS.SATURN.diffuse)!,
                          specular: nil,
                          emission: nil,
                          normal: nil,
                          time: PLANETS.SATURN.rotating,
                          position: SCNVector3(PLANETS.SATURN.AU, 0, 0),
                          inclination: PLANETS.SATURN.inclination)
      saturn.renderingOrder = 310
      saturn.geometry?.firstMaterial?.lightingModel = .constant
      saturnParent.addChildNode(saturn)
      
      let saturnOrbit = makeOrbit(position: PLANETS.SATURN.AU)
      saturnOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      saturnOrbit.opacity = 0.4
      saturnOrbit.renderingOrder = 320
      saturnParent.addChildNode(saturnOrbit)

      let uranus = planet(radius: CGFloat(PLANETS.URANUS.radius),
                          diffuse: UIImage(named: PLANETS.URANUS.diffuse)!,
                          specular: nil,
                          emission: nil,
                          normal: nil,
                          time: PLANETS.URANUS.rotating,
                          position: SCNVector3(0, 0, -PLANETS.URANUS.AU),
                          inclination: PLANETS.URANUS.inclination)
      uranus.renderingOrder = 330
      uranus.geometry?.firstMaterial?.lightingModel = .constant
      uranusParent.addChildNode(uranus)
      
      let uranusOrbit = makeOrbit(position: PLANETS.URANUS.AU)
      uranusOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      uranusOrbit.opacity = 0.4
      uranusOrbit.renderingOrder = 340
      uranusParent.addChildNode(uranusOrbit)

      let neptune = planet(radius: CGFloat(PLANETS.NEPTUNE.radius),
                           diffuse: UIImage(named: PLANETS.NEPTUNE.diffuse)!,
                           specular: nil,
                           emission: nil,
                           normal: nil,
                           time: PLANETS.NEPTUNE.rotating,
                           position: SCNVector3(0, 0, PLANETS.NEPTUNE.AU),
                           inclination: PLANETS.NEPTUNE.inclination)
      neptune.renderingOrder = 350
      neptune.geometry?.firstMaterial?.lightingModel = .constant
      neptuneParent.addChildNode(neptune)
      
      let neptuneOrbit = makeOrbit(position: PLANETS.NEPTUNE.AU)
      neptuneOrbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      neptuneOrbit.opacity = 0.4
      neptuneOrbit.renderingOrder = 360
      neptuneParent.addChildNode(neptuneOrbit)


      let sunRotation = rotation(time: PLANETS.SUN.rotating)
      sun.runAction(sunRotation)

      //let mercuryRotation = rotation(time: PLANETS.MERCURY.rotating)
      //mercury.runAction(mercuryRotation)
      
      let mercuryParentRotation = rotation(time: PLANETS.MERCURY.revolution)
      mercuryParent.runAction(mercuryParentRotation)

      //let venusRotation = rotation(time: PLANETS.VENUS.rotating)
      //venus.runAction(venusRotation)
      
      let venusParentRotation = rotation(time: PLANETS.VENUS.revolution)
      venusParent.runAction(venusParentRotation)

      //let earthRotation = rotation(time: PLANETS.EARTH.rotating)
      //earth.runAction(earthRotation)

      let earthParentRotation = rotation(time: PLANETS.EARTH.revolution)
      earthParent.runAction(earthParentRotation)

//      let moonParentRotation = rotation(time: 3)
//      moonParent.runAction(moonParentRotation)

      //let marsRotation = rotation(time: PLANETS.MARS.rotating)
      //mars.runAction(marsRotation)
      
      let marsParentRotation = rotation(time: PLANETS.MARS.revolution)
      marsParent.runAction(marsParentRotation)

      //let jupiterRotation = rotation(time: PLANETS.JUPITER.rotating)
      //jupiter.runAction(jupiterRotation)
      
      let jupiterParentRotation = rotation(time: PLANETS.JUPITER.revolution)
      jupiterParent.runAction(jupiterParentRotation)

      //let saturnRotation = rotation(time: PLANETS.SATURN.rotating)
      //saturn.runAction(saturnRotation)
      
      let saturnParentRotation = rotation(time: PLANETS.SATURN.revolution)
      saturnParent.runAction(saturnParentRotation)

      //let uranusRotation = rotation(time: PLANETS.URANUS.rotating)
      //uranus.runAction(uranusRotation)
      
      let uranusParentRotation = rotation(time: PLANETS.URANUS.revolution)
      uranusParent.runAction(uranusParentRotation)

      //let neptuneRotation = rotation(time: PLANETS.NEPTUNE.rotating)
      //neptune.runAction(neptuneRotation)
      
      let neptuneParentRotation = rotation(time: PLANETS.NEPTUNE.revolution)
      neptuneParent.runAction(neptuneParentRotation)
      
      return parentNode
   }
   
   
   func rotation(time: TimeInterval) -> SCNAction {
      let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
      let forever = SCNAction.repeatForever(rotation)
      
      return forever
   }
   
}


extension Int {
   var degreesToRadians: Double { return Double(self) * .pi/180}
}

