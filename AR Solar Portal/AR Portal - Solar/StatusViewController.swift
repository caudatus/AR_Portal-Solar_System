//
//  StatusViewController.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 16/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import ARKit
import UIKit

/**
 Displayed at the top of the main interface of the app that allows users to see
 the status of the AR experience, as well as the ability to control restarting
 the experience altogether.
 - Tag: StatusViewController
 */
class StatusViewController: UIViewController {
   // MARK: - Types
   
   enum MessageType {
      case trackingStateEscalation
      case planeEstimation
      case contentPlacement
      case focusSquare
      
      static var all: [MessageType] = [
         .trackingStateEscalation,
         .planeEstimation,
         .contentPlacement,
      ]
   }
   
   // MARK: - IBOutlets
   
   @IBOutlet weak var messagePanel: UIVisualEffectView!
   @IBOutlet weak var messageLabel: UILabel!
   @IBOutlet weak var restartExperienceButton: UIButton!
   
   
   // MARK: - Properties
   
   /// Trigerred when the "Restart Experience" button is tapped.
   var restartExperienceHandler: () -> Void = {}
   
   /// Seconds before the timer message should fade out.
   private let displayDuration: TimeInterval = 5
   
   /// Timer for hiding messages.
   private var messageHideTimer: Timer?
   
   private var timers: [MessageType: Timer] = [:]
   
   
   // MARK: - Message Handling
   
   func showMessage(_ text: String, autoHide: Bool = true) {
      // Cancel any previous hide timer.
      messageHideTimer?.invalidate()
      
      messageLabel.text = text
      
      // Make sure status is showing.
      setMessageHidden(false, animated: true)
      
      if autoHide {
         messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
            self?.setMessageHidden(true, animated: true)
         })
      }
   }
   
   func scheduleMessage(_ text: String, inSeconds seconds: TimeInterval, messageType: MessageType) {
      cancelScheduledMessage(for: messageType)
      
      let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] timer in
         self?.showMessage(text)
         timer.invalidate()
      })
      
      timers[messageType] = timer
   }
   
   func cancelScheduledMessage(for messageType: MessageType) {
      timers[messageType]?.invalidate()
      timers[messageType] = nil
   }
   
   func cancelAllScheduledMessages() {
      for messageType in MessageType.all {
         cancelScheduledMessage(for: messageType)
      }
   }
   
   // MARK: - ARKit
   
   func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState, autoHide: Bool) {
      showMessage(trackingState.presentationString, autoHide: autoHide)
   }
   
   func escalateFeedback(for trackingState: ARCamera.TrackingState, inSeconds seconds: TimeInterval) {
      cancelScheduledMessage(for: .trackingStateEscalation)
      
      let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [unowned self] _ in
         self.cancelScheduledMessage(for: .trackingStateEscalation)
         
         var message = trackingState.presentationString
         if let recommendation = trackingState.recommendation {
            message.append(": \(recommendation)")
         }
         
         self.showMessage(message, autoHide: false)
      })
      
      timers[.trackingStateEscalation] = timer
   }
   
   // MARK: - IBActions
   @IBAction func restartExperience(_ sender: UIButton) {
      restartExperienceHandler()
   }
   
   
   // MARK: - Panel Visibility
   
   private func setMessageHidden(_ hide: Bool, animated: Bool) {
      // The panel starts out hidden, so show it before animating opacity.
      messagePanel.isHidden = false
      
      guard animated else {
         messagePanel.alpha = hide ? 0 : 1
         return
      }
      
      UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
         self.messagePanel.alpha = hide ? 0 : 1
      }, completion: nil)
   }
}



extension ARCamera.TrackingState {
   var presentationString: String {
      switch self {
      case .notAvailable:
         return "notAvailable".localized
      case .normal:
         return "normal".localized
      case .limited(.excessiveMotion):
         return "excessiveMotion".localized
      case .limited(.insufficientFeatures):
         return "insufficientFeatures".localized
      case .limited(.initializing):
         return "initializing".localized
      case .limited(.relocalizing):
         return "relocalizing".localized
      }
   }
   
   var recommendation: String? {
      switch self {
      case .limited(.excessiveMotion):
         return "r_excessiveMotion".localized
      case .limited(.insufficientFeatures):
         return "r_insufficientFeatures".localized
      case .limited(.relocalizing):
         return "r_relocalizing".localized
      default:
         return nil
      }
   }
}
