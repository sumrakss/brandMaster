//
//  SettingsMeasureType.swift
//  BrandMaster20
//
//  Created by Алексей on 09.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SettingsMeasureType: UITableViewController {

   // MARK: - IBOutlets
	@IBOutlet weak var firstCell: UITableViewCell!
	@IBOutlet weak var secondCell: UITableViewCell!
	
	@IBOutlet weak var firstCellLabel: UILabel!
	@IBOutlet weak var secondCellLabel: UILabel!

	
	
	// MARK: - LifeCircle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupMeasureScreen()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updateMeasureScreen()
	}
	
	
	// MARK: - Private Methods
	
	private func setupMeasureScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = ""
		
		firstCell.accessoryType = .checkmark
		
		firstCellLabel.text = "кгс/см\u{00B2}"
		secondCellLabel.text = "МРа"
	}
	
	private func updateMeasureScreen() {
		firstCell.accessoryType = Parameters.shared.measureType == .kgc ? .checkmark : .none
		secondCell.accessoryType = Parameters.shared.measureType == .mpa ? .checkmark : .none
	}
	

	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			switch indexPath.row {
				case 0:
					Parameters.shared.setMeasureType(measure: .kgc)
					firstCell.accessoryType = .checkmark
					secondCell.accessoryType = .none
				case 1:
					Parameters.shared.setMeasureType(measure: .mpa)
					firstCell.accessoryType = .none
					secondCell.accessoryType = .checkmark
				default:
				break
			}
			tableView.reloadData()
		}
	}

}
