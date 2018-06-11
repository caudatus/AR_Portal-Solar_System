//
//  MainViewController+PlanetListDelegate.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 17/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import Foundation
import ARKit

extension MainViewController: PlanetListViewControllerDelegate {
   func planetSelectionViewController(_ selectionViewController: PlanetListViewController, didSelectObject: String, indexPath: IndexPath) {
      
      displayObjectLoadingUI()
      
      let portalName: String = "PORTAL"
      let name = didSelectObject
      removePlanet()
      
      if name == portalName {
         //make portal
         guard let planeAnchor = currentPlaneAnchor else {return}
         
         if isMakePortalAvailable {
            isMakePortalAvailable = false
            planetLoader.loadedPlanetIndex.insert(0)
            
            statusViewController.cancelScheduledMessage(for: .contentPlacement)
            addPortal(anchor: planeAnchor)
            generator = nil
            
         } else {
            // show the existing portal message
            statusViewController.showMessage("existing".localized)
         }
      } else {
         // selected planet load
         statusViewController.cancelScheduledMessage(for: .contentPlacement)
         sceneView.scene.rootNode.addChildNode(
            planetLoader.loadPlanet(
               with: name,
               anchor: currentPlaneAnchor!))
         
         isMakePortalAvailable = true
         //generator = nil
      }
      planetLoader.loadedPlanetIndex.insert(indexPath.row)
      
      hideObjectLoadingUI()
   }
   
   
   func planetSelectionViewController(_ selectionViewController: PlanetListViewController, didDeselectObject: String, indexPath: IndexPath) {
      removePlanet()
      if didDeselectObject == "PORTAL" {
         isMakePortalAvailable = true
      }
   }
   
   
   func addPortal(anchor: ARPlaneAnchor) {
      sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
         node.removeFromParentNode()
      }
      
      let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
      let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
      let planeXposition = anchor.transform.columns.3.x
      let planeYposition = anchor.transform.columns.3.y
      let planeZposition = anchor.transform.columns.3.z
      portalNode.position =  SCNVector3(planeXposition, planeYposition, planeZposition)
      
      addPlane(parentNode: portalNode)
      addWalls(parentNode: portalNode)
      
      let solarSystemNode = planetLoader.loadPlanetSolarSystem()
      portalNode.addChildNode(solarSystemNode)
      
      sceneView.scene.rootNode.addChildNode(portalNode)
      
   }
   
   
   func removePlanet() {
      sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
         node.removeFromParentNode()
      }
      planetLoader.loadedPlanetIndex.removeAll()
   }
   
   
   // MARK: Object Loading UI
   
   func displayObjectLoadingUI() {
      // Show progress indicator.
      spinner.startAnimating()
      
      addObjectButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
      
      addObjectButton.isEnabled = false
      isRestartAvailable = false
   }
   
   func hideObjectLoadingUI() {
      // Hide progress indicator.
      spinner.stopAnimating()
      
      addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
      addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
      
      addObjectButton.isEnabled = true
      isRestartAvailable = true
   }
   
   
}
