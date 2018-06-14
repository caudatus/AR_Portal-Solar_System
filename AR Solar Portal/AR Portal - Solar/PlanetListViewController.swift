//
//  PlanetListViewController.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 16/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//

import ARKit
import UIKit

// MARK: - ObjectCell

class PlanetCell: UITableViewCell {
   static let reuseIdentifier = "PlanetCell"
   
   @IBOutlet weak var planetTitleLabel: UILabel!
   @IBOutlet weak var planetImageView: UIImageView!
   @IBOutlet weak var vibrancyView: UIVisualEffectView!
   
   var modelName = "" {
      didSet {
         planetTitleLabel.text = modelName.localized
         planetImageView.image = UIImage(named: modelName+"_I")
      }
   }
}



// MARK: - PlanetListViewControllerDelegate

/// A protocol for reporting which planet have been selected.
protocol PlanetListViewControllerDelegate: class {
   func planetSelectionViewController(_ selectionViewController: PlanetListViewController, didSelectObject: String, indexPath: IndexPath)
   func planetSelectionViewController(_ selectionViewController: PlanetListViewController, didDeselectObject: String, indexPath: IndexPath)
}



class PlanetListViewController: UITableViewController {
   
   var names = ["PORTAL", "SUN", "MERCURY", "VENUS", "EARTH", "MARS", "JUPITER", "SATURN", "URANUS", "NEPTUNE"]
   
   /// The rows of the currently selected `Planet`s.
   var selectedPlanetsRows = IndexSet()
   
   /// The rows of the 'Planet's that are currently allowed to be placed.
   //var enabledPlanetsRows = Set<Int>()
   
   weak var delegate: PlanetListViewControllerDelegate?
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
   }
   
   
   override func viewWillLayoutSubviews() {
      preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
   }
   
   
   // MARK: - Table view data source
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return names.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetCell.reuseIdentifier, for: indexPath) as? PlanetCell else {
         fatalError("Expected `\(PlanetCell.self)` type for reuseIdentifier \(PlanetCell.reuseIdentifier). Check the configuration in Main.storyboard.")
      }
      cell.modelName = names[indexPath.row]
      
      if selectedPlanetsRows.contains(indexPath.row) {
         cell.accessoryType = .checkmark
      } else {
         cell.accessoryType = .none
      }
      
      let cellIsEnabled = selectedPlanetsRows.contains(indexPath.row)
      if cellIsEnabled {
         cell.vibrancyView.alpha = 0.1
      } else {
         cell.vibrancyView.alpha = 1.0
      }
      
      return cell
   }
   
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let objectName = names[indexPath.row]
      
      // Check if the current row is already selected, then deselect it.
      if selectedPlanetsRows.contains(indexPath.row) {
         delegate?.planetSelectionViewController(self, didDeselectObject: objectName, indexPath: indexPath)
      } else {
         delegate?.planetSelectionViewController(self, didSelectObject: objectName, indexPath: indexPath)
      }
      
      dismiss(animated: true, completion: nil)
   }
   
   
}
