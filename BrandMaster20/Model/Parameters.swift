import Foundation
import UIKit

// Типы дыхательного аппарата
enum DeviceType {
    case air
    case oxigen
}


// Единицы измерения расчетов
enum MeasureType {
    case kgc
    case mpa
}


struct Parameters {
    
    static var shared = Parameters()
    
    private init() {}
    
    
    // MARK: - Условия работы
    
    // Очаг найден
    var isFireFound = true
    // Сложные условия true/false
    var isHardWork = false
    // Время включения
    var startTime = Date()
    // Время у очага
    var fireTime = Date()
    // Давление при включении
    var enterPressureData = [Double]()
    // Давление у очага
    var firePressureData = [Double]()
    // Падение давления в звене
    var fallPressureData = [Double]()
    
    
    // MARK: - Настройки приложения
    
    //  Тип СИЗОД. По-умолчанию ДАСВ
    var deviceType = DeviceType.air
    // Единицы измерения.
    var measureType = MeasureType.kgc
    // Ручной ввод давления (точность)
    var accuracyMode = false
    // Учитывать звуковой сигнал в расчетах
    var airSignalMode = true
    // Показать простое решение
    var showSimpleSolution = false
    
    // Размер шрифта текста
    var fontSize = 18.0
    
    
    // MARK: - Параметры дахательного аппарата
    
    // Объем баллона
    var airVolume = 6.8
    // Средний расход воздуха
    var airRate = 40.0
    // Коэффициент сжимаемости воздуха
    var airIndex = 1.1
    // давление воздуха, необходимое для устойчивой работы редуктора
    var reductorPressure = 10.0
    // Давление срабатывания звукового сигнала
    var airSignal = 55.0
    
    var airSignalFlag = false
    
    var airFlow: Double {
        get {
            switch deviceType {
                case .air:
                    return airIndex * airRate
                case .oxigen:
                    return Parameters.shared.measureType == .kgc ? 2.0 : 0.2
            }
        }
    }
    

    // MARK: - Pickerview
    
    var pickerComponents = [String]()    // Содержимое pickerview

    mutating func generatePickerData() {
        var value = 300.0
        switch Parameters.shared.measureType {
            case .kgc:
                while value >= 100 {
                    pickerComponents.append(String(Int(value)))
                    value -= 5
                }
            case .mpa:
                value = 30
                while value >= 10 {
                    
                    pickerComponents.append(String(value))
                    value -= 0.5
                }
        }
    }

    
    // Сохраняем значение давления
    func setPressureData(for enterArray: [Double], for fireArray: [Double]) {
        Parameters.shared.enterPressureData.removeAll()
        Parameters.shared.firePressureData.removeAll()
        Parameters.shared.fallPressureData.removeAll()
        
        Parameters.shared.enterPressureData = enterArray
        Parameters.shared.firePressureData = fireArray
        for item in 0..<enterArray.count {
            Parameters.shared.fallPressureData.append(Parameters.shared.enterPressureData[item] - Parameters.shared.firePressureData[item])
        }
    }
    
    
    func setDeviceType(device: DeviceType ) {
        switch device {
            case .air:
                Parameters.shared.deviceType = .air
            case .oxigen:
                Parameters.shared.deviceType = .oxigen
        }
    }
    
    func setMeasureType(measure: MeasureType ) {
        switch measure {
            case .kgc:
                Parameters.shared.measureType = .kgc
            case .mpa:
                Parameters.shared.measureType = .mpa
        }
    }
    
}
