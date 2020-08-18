//
//  InfoJsonParser.swift
//  BrandMaster20
//
//  Created by Алексей on 12.08.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation


struct Answer: Codable {
    var info: [Info]
}


struct Info: Codable {
    let service: [String]
    let functionals: [String]
    let inner: [String]
    let maintenance: [String]
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
        return answer.info
    } catch {
        print("Error... \(error.localizedDescription)")
        return nil
    }
}
