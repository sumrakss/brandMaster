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
	
	
	@IBOutlet weak var fireplaceLabel: UILabel!
	@IBOutlet weak var workConditionsLabel: UILabel!
	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var fireplaceTimeLabel: UILabel!
	
	@IBOutlet weak var fireplaceSwitch: UISwitch!
	@IBOutlet weak var workConditionSwitch: UISwitch!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		startScreenPresets()
    
    }

	func startScreenPresets() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Условия работы"
	}
    // MARK: - Table view data source


}
