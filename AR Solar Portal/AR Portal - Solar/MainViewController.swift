//
//  MainViewController.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 15/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import ARKit
import UIKit

class MainViewController: UIViewController {
   
   // MARK: - IBOutlets
   @IBOutlet weak var sceneView: ARSCNView!
   @IBOutlet weak var addObjectButton: UIButton!
   @IBOutlet weak var spinner: UIActivityIndicatorView!
   @IBOutlet weak var blurView: UIVisualEffectView!
   
   
   // MARK: - UI Elements
   
   /// The view controller that displays the status and "restart experience" UI.
   lazy var statusViewController: StatusViewController = {
      return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
   }()
   
   
   // MARK: - ARKit Configuration Properties
   
   /// Marks if the AR experience is available for restart.
   var isRestartAvailable = true
   
   /// Marks if the Portal is available to make
   var isMakePortalAvailable = true
   
   var screenCenter: CGPoint {
      let bounds = sceneView.bounds
      return CGPoint(x: bounds.midX, y: bounds.midY)
   }
   
   /// Convenience accessor for the session owned by ARSCNView.
   var session: ARSession {
      return sceneView.session
   }
   
   
   // MARK: - View Controller Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupCamera()
      
      // Hook up status view controller callback(s).
      statusViewController.restartExperienceHandler = { [unowned self] in
         self.restartExperience()
      }
      
      self.sceneView.delegate = self
      self.sceneView.session.delegate = self
      self.sceneView.autoenablesDefaultLighting = false
      self.sceneView.automaticallyUpdatesLighting = true
      
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      self.sceneView.addGestureRecognizer(tapGestureRecognizer)
      
      UIApplication.shared.windows.first?.rootViewController = self
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      // Prevent the screen from being dimmed to avoid interuppting the AR experience.
      UIApplication.shared.isIdleTimerDisabled = true
      
      // Start the `ARSession`.
      resetTracking()
   }
   
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      session.pause()
   }
   
   
   // MARK: - Scene content setup
   
   enum SegueIdentifier: String {
      case showPlanets
   }
   
   /// The parent object that contain the planet objects.
   var planetLoader = PlanetLoader()
   
   /// The view controller that displays the virtual object selection menu.
   var planetListViewController: PlanetListViewController?
   
   func setupCamera() {
      guard let camera = sceneView.pointOfView?.camera else {
         fatalError("Expected a valid `pointOfView` from the scene.")
      }
      
      /*
       Enable HDR camera settings for the most realistic appearance
       with environmental lighting and physically based materials.
       */
      camera.wantsHDR = true
      camera.exposureOffset = -1
      camera.minimumExposure = -1
      camera.maximumExposure = 3
   }
   
   /// Save the anchor when call the didAdd method after succeed in plane detecting
   var currentPlaneAnchor:ARPlaneAnchor?
   
   /// Objects that generate haptic signals during plane detection
   var generator: UIImpactFeedbackGenerator? = nil
   
   
   // MARK: - Session management
   
   /// Creates a new AR configuration to run on the `session`.
   func resetTracking() {
      
      let configuration = ARWorldTrackingConfiguration()
      configuration.planeDetection = [.horizontal]
      
      session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
      
      statusViewController.scheduleMessage("find".localized, inSeconds: 7.5, messageType: .planeEstimation)
      
      generator = UIImpactFeedbackGenerator()
      generator?.prepare()
   }
   
   
   // MARK: - Error handling
   
   func displayErrorMessage(title: String, message: String) {
      blurView.isHidden = false
      
      // Present an alert informing about the error that has occurred.
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
         alertController.dismiss(animated: true, completion: nil)
         self.blurView.isHidden = true
         self.resetTracking()
      }
      alertController.addAction(restartAction)
      present(alertController, animated: true, completion: nil)
   }
   
   
   // MARK: - Interface Actions
   
   @IBAction func addButtonPressed(_ sender: UIButton) {
      guard !addObjectButton.isHidden else { return }
      
      statusViewController.cancelScheduledMessage(for: .contentPlacement)
      performSegue(withIdentifier: SegueIdentifier.showPlanets.rawValue, sender: addObjectButton)
   }
   
   
   @objc func handleTap(sender: UITapGestureRecognizer) {
      guard let sceneView = sender.view as? ARSCNView else {return}
      let touchLocation = sender.location(in: sceneView)
      let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
      
      if !hitTestResult.isEmpty {
         if isMakePortalAvailable {
            isMakePortalAvailable = false
            planetLoader.loadedPlanetIndex.insert(0)
            
            statusViewController.cancelScheduledMessage(for: .contentPlacement)
            self.addPortal(hitTestResult: hitTestResult.first!)
            generator = nil
         } else {
            statusViewController.showMessage("existing".localized)
         }
      } else {
         guard !addObjectButton.isHidden else { return }
         
         statusViewController.cancelScheduledMessage(for: .contentPlacement)
         performSegue(withIdentifier: SegueIdentifier.showPlanets.rawValue, sender: addObjectButton)
      }
   }
   
   
   /// - Tag: restartExperience
   func restartExperience() {
      guard isRestartAvailable else { return }
      isRestartAvailable = false
      isMakePortalAvailable = false
      
      statusViewController.cancelAllScheduledMessages()
      
      addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
      addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
      
      sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
         node.removeAllActions()
         node.removeFromParentNode()
      }
      
      resetTracking()
      
      addObjectButton.isHidden = true
      planetLoader.loadedPlanetIndex.removeAll()
      currentPlaneAnchor = nil
      
      // Disable restart for a while in order to give the session time to restart.
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
         self.isRestartAvailable = true
         self.isMakePortalAvailable = true
      }
   }
   
   
   func addPortal(hitTestResult: ARHitTestResult) {
      sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
         node.removeFromParentNode()
      }
      
      let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
      let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
      let transform = hitTestResult.worldTransform
      let planeXposition = transform.columns.3.x
      let planeYposition = transform.columns.3.y
      let planeZposition = transform.columns.3.z
      portalNode.position =  SCNVector3(planeXposition, planeYposition, planeZposition)
      
      let solarSystemNode = planetLoader.loadPlanetSolarSystem()
      portalNode.addChildNode(solarSystemNode)
      
      addPlane(nodeName: "roof", portalNode: portalNode, imageName: "stars_milky_way")
      addPlane(nodeName: "floor", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "midDoorA", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "midDoorB", portalNode: portalNode, imageName: "stars_milky_way")
      addWalls(nodeName: "portalDoor", portalNode: portalNode, imageName: "PORTAL")
      
      sceneView.scene.rootNode.addChildNode(portalNode)
   }
   
   
   func addWalls(nodeName: String, portalNode: SCNNode, imageName: String) {
      let child = portalNode.childNode(withName: nodeName, recursively: true)
      
      if nodeName == "portalDoor" {
         child?.geometry?.firstMaterial?.isDoubleSided = true
         child?.geometry?.firstMaterial?.emission.contents = UIImage(named: "stars_milky_way")
         
         let portalRotation = rotation(time: 5)
         child?.runAction(portalRotation)
      }
      
      child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(imageName)")
      child?.renderingOrder = 200
      
      if let mask = child?.childNode(withName: "mask", recursively: false) {
         mask.geometry?.firstMaterial?.transparency = 0.000001
      }
   }
   
   
   func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
      let child = portalNode.childNode(withName: nodeName, recursively: true)
      child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(imageName)")
      child?.renderingOrder = 200
   }

   
   func rotation(time: TimeInterval) -> SCNAction {
      let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
      let forever = SCNAction.repeatForever(rotation)
      
      return forever
   }
   
   
}
