//
//  MainViewController+Action.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 17/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import Foundation
import ARKit

extension MainViewController: UIPopoverPresentationControllerDelegate {
   
   // MARK: - UIPopoverPresentationControllerDelegate
   
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
   
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // All menus should be popovers (even on iPhone).
      if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
         popoverController.delegate = self
         popoverController.sourceView = button
         popoverController.sourceRect = button.bounds
      }
      
      guard let identifier = segue.identifier,
         let segueIdentifer = SegueIdentifier(rawValue: identifier),
         segueIdentifer == .showPlanets else { return }
      
      let planetViewController = segue.destination as! PlanetListViewController
      planetViewController.delegate = self
      
      self.planetListViewController = planetViewController
      if let loadedIndex = planetLoader.loadedPlanetIndex.first {
         self.planetListViewController?.selectedPlanetsRows.insert(loadedIndex)
      }

   }
   
   func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
      planetListViewController = nil
   }
}
