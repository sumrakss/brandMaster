//
//  MainScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 27.07.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class MainScreen: UITableViewController {
	
	// MARK: - IBOutlets
	
	// Section 0
	@IBOutlet weak var fireStatusLabel: UILabel!
	@IBOutlet weak var workStatusLabel: UILabel!
	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var fireTimeLabel: UILabel!
	
	@IBOutlet weak var fireplaceSwitch: UISwitch!
	@IBOutlet weak var workConditionSwitch: UISwitch!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		startScreenPresets()
    
    }

	// Настройка главного экрана
	func startScreenPresets() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Условия работы"
		
		fireStatusLabel.text = "Очаг - обнаружен"
		workStatusLabel.text = "Условия - нормальные"
		
		fireplaceSwitch.isOn = true
		workConditionSwitch.isOn = false
	}
    
	
	// MARK: - IBActions
	
	@IBAction func fireStatusSelector(_ sender: UISwitch) {
		fireStatusLabel.text = fireplaceSwitch.isOn ? "Очаг - обнаружен" : "Очаг - поиск"
	}
	
	
	@IBAction func workStatusSelector(_ sender: UISwitch) {
		workStatusLabel.text = workConditionSwitch.isOn ? "Условия - сложные" : "Условия - нормальные"
	}
	
	
	@IBAction func teamSizeSelector(_ sender: UIStepper) {
	}
	
	
	
	// MARK: - Table view data source
	
	var tap = false
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0, indexPath.row == 3 {
			return (tap ? tableView.rowHeight : 0)
		}
		
		if indexPath.section == 0, indexPath.row == 5 {
			return (tap ? tableView.rowHeight : 0)
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0, indexPath.row == 2 {
			tap = !tap
			tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
		}
	}

}
