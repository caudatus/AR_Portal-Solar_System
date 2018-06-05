//
//  MainViewController+ARSCNViewDelegate.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 16/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import Foundation
import ARKit

extension MainViewController: ARSCNViewDelegate, ARSessionDelegate {
   
   func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
      guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
      
      if isMakePortalAvailable {
         let planeNode = createPlane(with: planeAnchor)
         node.addChildNode(planeNode)
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hide(node: node)
         }
         
         DispatchQueue.main.async {
            self.generator?.impactOccurred()
            self.addObjectButton.isHidden = false
            
            self.statusViewController.cancelScheduledMessage(for: .planeEstimation)
            self.statusViewController.showMessage("detected".localized)
            if self.isMakePortalAvailable {
               self.statusViewController.scheduleMessage("tapto".localized, inSeconds: 7.5, messageType: .contentPlacement)
            }
         }
         
         currentPlaneAnchor = planeAnchor
         
      }
   }
   
   
   func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
      
      if isMakePortalAvailable {
         node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
         }
         let planeNode = createPlane(with: planeAnchor)
         node.addChildNode(planeNode)
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hide(node: node)
         }
      }
   }
   
   
   func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
      statusViewController.showTrackingQualityInfo(for: camera.trackingState, autoHide: true)
      
      switch camera.trackingState {
      case .notAvailable, .limited:
         statusViewController.escalateFeedback(for: camera.trackingState, inSeconds: 3.0)
      case .normal:
         statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
         
      }
   }
   
   
   func session(_ session: ARSession, didFailWithError error: Error) {
      guard error is ARError else { return }
      
      let errorWithInfo = error as NSError
      let messages = [
         errorWithInfo.localizedDescription,
         errorWithInfo.localizedFailureReason,
         errorWithInfo.localizedRecoverySuggestion
      ]
      
      // Use `flatMap(_:)` to remove optional error messages.
      let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
      
      DispatchQueue.main.async {
         self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
      }
   }
   
   
   func sessionWasInterrupted(_ session: ARSession) {
      // Hide content before going into the background.
      sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
         node.removeFromParentNode()
      }
   }
   
   
   func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
      /*
       Allow the session to attempt to resume after an interruption.
       This process may not succeed, so the app must be prepared
       to reset the session if the relocalizing status continues
       for a long time -- see `escalateFeedback` in `StatusViewController`.
       */
      return true
   }
   
   
   func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
      let node = SCNNode(geometry: SCNPlane(
            width: CGFloat(planeAnchor.extent.x),
            height: CGFloat(planeAnchor.extent.z)))
      
      node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
      node.geometry?.firstMaterial?.isDoubleSided = true
      node.opacity = 0.5
      node.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
      node.position = SCNVector3(
         planeAnchor.center.x,
         planeAnchor.center.y,
         planeAnchor.center.z)
      node.renderingOrder = 100
      
      let innerNode = SCNNode(geometry: SCNPlane(
         width: CGFloat(planeAnchor.extent.x - 0.05),
         height: CGFloat(planeAnchor.extent.z - 0.05)))
      
      innerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
      innerNode.geometry?.firstMaterial?.isDoubleSided = true
      innerNode.position = SCNVector3(0, 0, -0.01)
      innerNode.geometry?.firstMaterial?.transparency = 0.00001
      
      let staticBody = SCNPhysicsBody.static()
      node.physicsBody = staticBody
      
      node.addChildNode(innerNode)
      return node
   }
   
   
   func hide(node: SCNNode) {
         guard node.action(forKey: "hide") == nil else { return }
         node.runAction(.fadeOut(duration: 0.5), forKey: "hide")
   }
   
   
   func unhide(node: SCNNode) {
      guard node.action(forKey: "unhide") == nil else { return }
      node.runAction(.fadeIn(duration: 0.1), forKey: "unhide")
   }
   
}
