//
//  UserSettings.swift
//  BrandMaster20
//
//  Created by Алексей on 18/08/2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

final class UserSettings {
    
    var param = Parameters.shared
    let defaults = UserDefaults.standard
    
    let key = "userSettings"
    
    func saveSettings() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: param, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: key)
        }
        
        
        param = loadSettings()
        print(param)
    }
    
    func loadSettings() -> Parameters {
        guard let savedData = defaults.object(forKey: key) as? Data,
            let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Parameters else {
            return param
        }
        return decodedData
    }
    
    func resetSettings() {
        
    }
}
