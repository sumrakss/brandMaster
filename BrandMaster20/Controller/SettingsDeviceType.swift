//
//  TypeSelectorScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 08.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SettingsDeviceType: UITableViewController {
	
	// MARK: - IBOutlets
	@IBOutlet weak var firstCell: UITableViewCell!
	@IBOutlet weak var secondCell: UITableViewCell!
		 
	@IBOutlet weak var firstCellLabel: UILabel!
	@IBOutlet weak var secondCellLabel: UILabel!
	
	
	
	// MARK: - LifeCircle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTypeScreen()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updateTypeScreen()
	}
	
	
	// MARK: - Private Methods
	
	private func setupTypeScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = ""
		
		firstCell.accessoryType = .checkmark
		
		firstCellLabel.text = "ДАСВ (воздух)"
		secondCellLabel.text = "ДАСК (кислород)"
	}
	
	private func updateTypeScreen() {
		firstCell.accessoryType = Parameters.shared.deviceType == .air ? .checkmark : .none
		secondCell.accessoryType = Parameters.shared.deviceType == .oxigen ? .checkmark : .none
	}
	
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			switch indexPath.row {
				case 0:
					Parameters.shared.setDeviceType(device: .air)
					firstCell.accessoryType = .checkmark
					secondCell.accessoryType = .none
				case 1:
					Parameters.shared.setDeviceType(device: .oxigen)
					firstCell.accessoryType = .none
					secondCell.accessoryType = .checkmark
				default:
				break
			}
			tableView.reloadData()
		}
	}
	
}
