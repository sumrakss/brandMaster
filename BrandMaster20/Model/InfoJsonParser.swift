//
//  InfoJsonParser.swift
//  BrandMaster20
//
//  Created by Алексей on 12.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

struct Info: Codable {
    var functions: [Functions]		// Обязанности
    var service: [Service]			// Сизод
}

// Обязанности
struct Functions: Codable {
	let services: Services			// ГДЗС
	let functionals: Functionals	// Функциональные
	let orderly: Orderly			// Внутренний наряд
}

// ГДЗС
struct Services: Codable {
    let name: String
    let text: String
}

// Функциональные
struct Functionals: Codable {
    let name: String
    let text: String
}

// Внутренний наряд
struct Orderly: Codable {
    let name: String
    let text: String
}

// Сизод
struct Service: Codable {
    let name: String
    let text: String
}


struct Answer: Codable {
    var locations: [Info]
}


func parse(pathForFile: String) -> [Info]? {
    var d: Data?
    do {
        d = try Data(contentsOf: URL(fileURLWithPath: pathForFile))
    } catch {
        print("Ошибка получения Data: \(error.localizedDescription)")
        return nil
    }
    
    guard let data = d else {
        print("Error...")
        return nil
    }
    
    do {
        let answer = try JSONDecoder().decode(Answer.self, from: data)
        return answer.locations
    } catch {
        print("Error... \(error.localizedDescription)")
        return nil
    }
}

