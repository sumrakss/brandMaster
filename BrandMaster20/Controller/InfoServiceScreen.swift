//
//  InfoFunctionsScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 12.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class InfoServiceScreen: UITableViewController {
    
    let json = parse(pathForFile: Bundle.main.path(forResource: "infoData", ofType: "json")!)
    
	// MARK: - Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "serviceToDiplay", sender: self)
    }
    
    
	// MARK: - Segue
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "serviceToDiplay" {
            guard let vc = segue.destination as? InfoDisplayText else { return }
            let row = tableView.indexPathForSelectedRow!.row
            let section = tableView.indexPathForSelectedRow!.section
            
            switch section {
            case 0:
                vc.mainText = json![0].maintenance[row]

            default:
                break
            }
        }
    }
	
}
