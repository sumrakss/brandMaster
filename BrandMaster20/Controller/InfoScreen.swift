//
//  InfoScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 08.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class InfoScreen: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupInfoScreen()
	}
	
	
	// MARK: - Private Methods
	
	private func setupInfoScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Информация"
	}
	
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		// БрандМастер в ВК
		if indexPath.section == 1, indexPath.row == 0 {
			if let url = URL(string: "https://vk.com/brmeister") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		// Обратная связь
		if indexPath.section == 1, indexPath.row == 1 {
			let email = "bmasterfire@gmail.com"
			if let url = URL(string: "mailto:\(email)") {
				UIApplication.shared.open(url)
			}
		}
		
		// Политика конфиденциальности
		if indexPath.section == 1, indexPath.row == 2 {
			if let url = URL(string: "https://alekseyorehov.github.io/BrandMaster/") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		tableView.reloadRows(at: [indexPath], with: .none)
	}

}
