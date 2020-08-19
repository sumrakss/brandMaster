//
//  MainScreen.swift
//  BrandMaster20
//

/*
func saveSettings() {
       print("param")
       if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: param, requiringSecureCoding: false) {
           defaults.set(savedData, forKey: key)
       }
       
       guard let savedData = defaults.object(forKey: key) as? Data,
           let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Parameters else { return }
       
       
   }
   
   func loadSettings() -> Parameters {
      guard let savedData = defaults.object(forKey: key) as? Data,
       let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Parameters else { return Parameters }
       return decodedModel
   }
*/

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
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var fireTimePicker: UIDatePicker!
    @IBOutlet weak var fireplaceSwitch: UISwitch!
    @IBOutlet weak var workConditionSwitch: UISwitch!
    
    
    // Section 1
    @IBOutlet weak var teamSizeStepper: UIStepper! {
        didSet {
            teamSizeStepper.value = 3
            teamSizeStepper.minimumValue = 2
            teamSizeStepper.maximumValue = 5
        }
    }
    
    @IBOutlet weak var fireplaceLabel: UILabel!
    
    @IBOutlet var firemanData: [UIStackView]!
    @IBOutlet var startDataTextFields: [UITextField]!
    @IBOutlet var fireDataTextFields: [UITextField]!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStartScreen()
        setTeam(size: Int(teamSizeStepper!.value))
    }
    
    
    // MARK: - Private Methods
    
    private func setupStartScreen() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Условия работы"
        
        fireStatusLabel.text = "Очаг - обнаружен"
        workStatusLabel.text = "Условия - нормальные"
        
        fireplaceSwitch.isOn = true
        workConditionSwitch.isOn = false
        
        setTime(for: startTimeLabel, from: startTimePicker)
        setTime(for: fireTimeLabel, from: fireTimePicker)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    
    private func setTime(for label: UILabel, from picker: UIDatePicker) {
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        label.text = time.string(from: picker.date)
    }
    
    
    private func setTeam(size: Int) {
        // Скрываем все поля ввода
        for item in firemanData {
            item.isHidden  = true
        }
        // Показываем только необходимое количество строк ввода
        for i in 0..<(size) {
            firemanData[i].isHidden = false
        }
        // Данные из TF записываем в Parameters
        var enterArray = [Double]()
        var fireArray = [Double]()
        for i in 0..<(size) {
            if let enterData = startDataTextFields?[i].text,
                let fireData = fireDataTextFields?[i].text {
                enterArray.append(Double(enterData)!)
                fireArray.append(Double(fireData)!)
            }
        }
        Parameters.shared.setPressureData(for: enterArray, for: fireArray)  //
    }
    
    
    private func showFireUI() {
        fireTimeCellHidden = !fireTimeCellHidden
        fireTimePickerHidden = true
        fireplaceLabel.isHidden = !fireplaceLabel.isHidden
        
        if fireTimeCellHidden {
            fireDataTextFields.forEach {
                $0.isHidden = true
            }
        } else {
            fireDataTextFields.forEach {
                $0.isHidden  = false
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func calculate(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toPDF", sender: self)
    }
    
    
    @IBAction func fireFoundChange(_ sender: UISwitch) {
        fireStatusLabel.text = fireplaceSwitch.isOn ? "Очаг - обнаружен" : "Очаг - поиск"
        showFireUI()
        Parameters.shared.isFireFound = fireplaceSwitch.isOn  //
    }
    
    
    @IBAction func workStatusChange(_ sender: UISwitch) {
        workStatusLabel.text = workConditionSwitch.isOn ? "Условия - сложные" : "Условия - нормальные"
        Parameters.shared.isHardWork = workConditionSwitch.isOn   //
    }
    
    
    @IBAction func setEnterTime(_ sender: UIDatePicker) {
        setTime(for: startTimeLabel, from: sender)
        Parameters.shared.startTime = startTimePicker!.date   //
    }
    
    
    @IBAction func setFireTime(_ sender: UIDatePicker) {
        setTime(for: fireTimeLabel, from: sender)
        Parameters.shared.fireTime = fireTimePicker!.date    //
    }
    
    
    @IBAction func teamSizeChange(_ sender: UIStepper) {
        setTeam(size: Int(sender.value))
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    private var startTimePickerHidden = true
    private var fireTimePickerHidden = true
    private var fireTimeCellHidden = false
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0, indexPath.row == 3  {
            return (startTimePickerHidden ? 0 : 216)
        }
        
        if indexPath.section == 0, indexPath.row == 4  {
            return (fireTimeCellHidden ? 0 : tableView.rowHeight)
        }
        
        if indexPath.section == 0, indexPath.row == 5 {
            return (fireTimePickerHidden ? 0 : 216)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            startTimePickerHidden = !startTimePickerHidden
        case (0, 4):
            fireTimePickerHidden = !fireTimePickerHidden
        default:
            ()
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		var headerText = String()
		if section == 1 {
			switch Parameters.shared.measureType {
				case .kgc:
					headerText = "ДАВЛЕНИЕ В ЗВЕНЕ (кгс/см\u{00B2})"
				case .mpa:
					headerText = "ДАВЛЕНИЕ В ЗВЕНЕ (МПа)"
			}
		}
		return headerText
	}
    
    
     // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPDF" {
            guard let vc = segue.destination as? PDFPreviewScreen else { return }
            let pdfCreator = PDFCreator()

            if Parameters.shared.isFireFound {
                vc.documentData = pdfCreator.foundPDFCreator()
            } else {
                vc.documentData = pdfCreator.notFoundPDFCreator()
            }
        }
    }
    
    
}

