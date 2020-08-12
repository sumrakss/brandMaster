//
//  InfoFunctionsScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 12.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class InfoFunctionsScreen: UITableViewController {

	let data = parse(pathForFile: Bundle.main.path(forResource: "infoData", ofType: "json")!)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			
		}
	}
   

}
