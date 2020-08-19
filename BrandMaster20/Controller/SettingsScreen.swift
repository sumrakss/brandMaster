//
//  SettingsScreen.swift
//  BrandMaster20
//
//  Created by Алексей on 30.07.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SettingsScreen: UITableViewController {
	
	// MARK: - IBOutlets
	
	// Section 0
	@IBOutlet weak var deviceTypeDetailLabel: UILabel!
	@IBOutlet weak var measureTypeDetailLabel: UILabel!
	
	@IBOutlet weak var accuracySwitch: UISwitch!
	@IBOutlet weak var signalSwitch: UISwitch!
	@IBOutlet weak var showSimpleSwitch: UISwitch!
	
	// Section 1
	@IBOutlet weak var airRateDetailLabel: UILabel!
	@IBOutlet weak var reductorDetailLabel: UILabel!
	@IBOutlet weak var airSignalDetaillabel: UILabel!
	
	@IBOutlet weak var airRateCell: UITableViewCell!
	@IBOutlet weak var airIndexCell: UITableViewCell!
	
	@IBOutlet weak var airVolumeTextField: UITextField!
	@IBOutlet weak var airRateTextField: UITextField!
	@IBOutlet weak var airIndexTextField: UITextField!
	@IBOutlet weak var reductorPressureTextField: UITextField!
	@IBOutlet weak var airSignalTextField: UITextField!
	
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSettingsScreen()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		updateSettingsScreen()
	}
	
	
	// MARK: - Private Methods
	
	private func setupSettingsScreen() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Настройки"
		
		tableView.keyboardDismissMode = .onDrag
		
		accuracySwitch.isOn = false
		signalSwitch.isOn = true
		showSimpleSwitch.isOn = true
	}
	
	private func updateSettingsScreen() {
		
		switch Parameters.shared.deviceType {
			case .air:
				deviceTypeDetailLabel.text = "ДАСВ"
				airRateDetailLabel.text = "Средний расход воздуха (л/мин)"
				reductorDetailLabel.text = "Давление редуктора (кгс/см\u{00B2})"
			case .oxigen:
				deviceTypeDetailLabel.text = "ДАСК"
				reductorDetailLabel.text = "Давление редуктора (MPa)"
		}
		
		switch Parameters.shared.measureType {
			case .kgc:
				measureTypeDetailLabel.text = "кгс/см\u{00B2}"
				reductorDetailLabel.text = "Давление редуктора (кгс/см\u{00B2})"
				airSignalDetaillabel.text = "Срабатывание сигнала (кгс/см\u{00B2})"
			case .mpa:
				measureTypeDetailLabel.text = "МПа"
				reductorDetailLabel.text = "Давление редуктора (МПа)"
				airSignalDetaillabel.text = "Срабатывание сигнала (МПа)"
		}
		tableView.reloadData()
	}
	
	// MARK: - IBActions
	
	@IBAction func accuracyModeChange(_ sender: UISwitch) {
		Parameters.shared.accuracyMode = accuracySwitch.isOn
	}
	
	@IBAction func airSignalModeChange(_ sender: UISwitch) {
		Parameters.shared.airSignalMode = signalSwitch.isOn
	}
	
	@IBAction func simpleSolutionModeChange(_ sender: UISwitch) {
		Parameters.shared.showSimpleSolution = showSimpleSwitch.isOn
	}
	
	@IBAction func setAirVolume(_ sender: UITextField) {
		Parameters.shared.airVolume = guardText(field: sender)
	}
	
	@IBAction func setAirRate(_ sender: UITextField) {
		Parameters.shared.airRate = guardText(field: sender)
	}
	
	@IBAction func setAirIndex(_ sender: UITextField) {
		Parameters.shared.airIndex = guardText(field: sender)
	}
	
	@IBAction func setReductorPressure(_ sender: UITextField) {
		Parameters.shared.reductorPressure = guardText(field: sender)
	}
	
	@IBAction func setAirSignal(_ sender: UITextField) {
		Parameters.shared.airSignal = guardText(field: sender)
	}
	
	
	let userDefaults = UserDefaults.standard
	
	@IBAction func resetSettings(_ sender: UIButton) {
		//        userDefaults.setValue(Parameters.shared, forKeyPath: "sharedSettings")
        let settings = UserSettings()
        settings.saveSettings()
	}
	
	
	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 1 ,indexPath.row == 2 {
				return (Parameters.shared.deviceType == .oxigen) ? 0 : tableView.rowHeight
		}
		
		if indexPath.section == 1 ,indexPath.row == 3 {
				return (Parameters.shared.deviceType == .oxigen) ? 0 : tableView.rowHeight
		}
		return tableView.rowHeight
	}
}



// MARK: - Extensions

extension String {
	
	// Подставляем разделитель в зависимости от системной локали
	static let numberFormatter = NumberFormatter()
	func dotGuard() -> Double {
		var doubleValue: Double {
			String.numberFormatter.decimalSeparator = ","
			if let result =  String.numberFormatter.number(from: self) {
				return result.doubleValue
			} else {
				String.numberFormatter.decimalSeparator = "."
				if let result = String.numberFormatter.number(from: self) {
					return result.doubleValue
				}
			}
			return 0
		}
		return doubleValue
	}
	
}


extension UITableViewController {
	
	// Проверяем текстовое поле на nil
	func guardText(field: UITextField) -> Double {
		if let senderValue = field.text?.dotGuard() {
			atencionMessageForText(field: field, value: senderValue)
			return senderValue
		}
		return 0.0
	}
	
	
	// Выводим предупреждение если значение некорректное или равно 0
	func atencionMessageForText(field: UITextField, value: Double) {
		let zeroType = Parameters.shared.deviceType == .air ? "0" : "0.0"
		guard value != 0.0
			else {
				let alert = UIAlertController(title: "Пустое поле!",
											  message: "Значение будет равно \(zeroType)",
					preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK",
											  style: .default,
											  handler: nil))
				present(alert, animated: true, completion: nil)
				field.text = zeroType
				return
		}
	}
	
}

