//
//  PDFCreator.swift
//  FireCalculator
//
//  Created by Алексей on 01.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
	
	// MARK: - Private Properties
	
	// Щрифты
	let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 16)!]
	let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]
	let bold = [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 16)!]
	let note = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]
	
	// PDF
	let format = UIGraphicsPDFRendererFormat()
	let pageWidth = 595.2 	// A4 Width
	let pageHeight = 841.8 	// A4 Height
	
	// Параметры расчетов
	let comp = Calculations()
	
	var value = String()
	var minEnterPressure = String()
	var minFirePressure = String()
	var reductor = String()
	var airRate = String()
	var maxFallPresure = String()
	var airFlow = String()
	var startPressure = String()
	var firePressure = String()
	let capacity = String(Parameters.shared.airVolume)
	let airIndex = String(Parameters.shared.airIndex)
	let airIndexStr = "сж"
	// Номер газодымзащитника с наибольшим падением давления
	let index = Parameters.shared.fallPressureData.firstIndex(of: Parameters.shared.fallPressureData.max()!)!
	
	
	// MARK: - Private Methods
	
	private func PDFdataFormatter() {
		
		switch Parameters.shared.measureType {
			case .kgc:
				value = "кгс/см\u{00B2}"
				minEnterPressure = String(Int(Parameters.shared.enterPressureData.min()!))
				minFirePressure = String(Int(Parameters.shared.firePressureData.min()!))
				reductor = String(Int(Parameters.shared.reductorPressure))
				airRate = String(Int(Parameters.shared.airRate))
				maxFallPresure = String(Int(Parameters.shared.fallPressureData.max()!))
				airFlow = String(Int(Parameters.shared.airFlow))
				startPressure = String(Int(Parameters.shared.enterPressureData[index]))
				firePressure = String(Int(Parameters.shared.firePressureData[index]))
			
			case .mpa:
				value = "МПа"
				minEnterPressure = String(Parameters.shared.enterPressureData.min()!)
				minFirePressure = String(Parameters.shared.firePressureData.min()!)
				reductor = String(Parameters.shared.reductorPressure)
				airRate = String(Parameters.shared.airRate)
				maxFallPresure = String(format:"%.1f", Parameters.shared.fallPressureData.max()!)
				airFlow = String(Parameters.shared.airFlow)
				startPressure = String(Parameters.shared.enterPressureData[index])
				firePressure = String(Parameters.shared.firePressureData[index])
		}
	}
	
	
	// MARK: - Public Methods
	
	// PDF-страница с примечаниями
	func marksViewer() -> Data{
		let pdfMetaData = [
			kCGPDFContextCreator: "Brandmaster",
			kCGPDFContextAuthor: "Aleksey Orekhov"
		]
		format.documentInfo = pdfMetaData as [String: Any]
		let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
		
		let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
		let data = renderer.pdfData { (context) in
			context.beginPage()
			let context = context.cgContext
			
			// Подставляем PDF шаблон с формулами
			let path = Bundle.main.path(forResource: "Marks", ofType: "pdf")!
			let url = URL(fileURLWithPath: path)
			let document = CGPDFDocument(url as CFURL)
			// Количество страниц
			let page = document?.page(at: 1)
			UIColor.white.set()
			context.translateBy(x: 0.0, y: pageRect.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
			context.drawPDFPage(page!)
		}
		return data
	}
	
	
	// Метод генерирует лист А4 c расчетами если очаг пожара найден.
	func foundPDFCreator() -> Data {
		
		// 1) Расчет общего времени работы (Тобщ)
		let totalTime = comp.totalTimeCalculation(minPressure: Parameters.shared.enterPressureData)
		// 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
		let expectedTime = comp.expectedTimeCalculation(inputTime: Parameters.shared.startTime, totalTime: totalTime)
		// 3) Расчет давления для выхода (Рк.вых)
		var exitPressure = comp.exitPressureCalculation(maxDrop: Parameters.shared.fallPressureData, hardChoice: Parameters.shared.isHardWork)
		// Pквых округлям при кгс и не меняем при МПа
		var exitPString = Parameters.shared.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
		
		if Parameters.shared.airSignalMode {
			if exitPressure < Parameters.shared.airSignal {
				exitPressure = Parameters.shared.airSignal
				Parameters.shared.airSignalFlag = true
			}
		}
		
		// 4) Расчет времени работы у очага (Траб)
		let workTime = comp.workTimeCalculation(minPressure: Parameters.shared.firePressureData, exitPressure: exitPressure)
		// 5) Время подачи команды постовым на выход звена
		let  exitTime = comp.expectedTimeCalculation(inputTime: Parameters.shared.fireTime, totalTime: workTime)
		
		PDFdataFormatter()
		
		// PDF
		let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
		let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
		
		let data = renderer.pdfData { (context) in
			context.beginPage()
			let context = context.cgContext
			
			//index
			String(index+1).draw(at: CGPoint(x: 510, y: 141), withAttributes: large)
			
			// 0
			
			var string = "= \(startPressure) - \(firePressure) = \(maxFallPresure) \(value)"
			string.draw(at: CGPoint(x: 310, y: 184), withAttributes: large)
			
			// 1
			switch Parameters.shared.deviceType {
				case .air:
					string = "\(airRate) * K"
					string.draw(at: CGPoint(x: 170, y: 289), withAttributes: large)
					airIndexStr.draw(at: CGPoint(x: 220, y: 294), withAttributes: small)
					
					string = "\(airRate) * \(airIndex)"
					string.draw(at: CGPoint(x: 335, y: 289), withAttributes: large)
				
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 205, y: 289), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 365, y: 289), withAttributes: large)
			}
			string = "(\(minEnterPressure) - \(reductor)) * \(capacity)"
			string.draw(at: CGPoint(x: 308, y: 267), withAttributes: large)
			
			string = "= \(String(format:"%.1f", totalTime)) ≈ \(Int(totalTime)) мин."
			string.draw(at: CGPoint(x: 428, y: 280), withAttributes: large)
			
			//2
			let time = DateFormatter()
			time.dateFormat = "HH"
			string = "\(time.string(from: Parameters.shared.startTime))    +    = \(expectedTime)"
			string.draw(at: CGPoint(x: 320, y: 371), withAttributes: large)
			
			time.dateFormat = "mm"
			string = "\(time.string(from: Parameters.shared.startTime))     \(Int(totalTime))"
			string.draw(at: CGPoint(x: 340, y: 368), withAttributes: small)
			
			
			// 3
			var formulaPat = ""	// шаблон
			if Parameters.shared.isHardWork {
				formulaPat = "P        = 2 * P            + P         "
				formulaPat.draw(at: CGPoint(x: 90, y: 478), withAttributes: bold)
				formulaPat = "к. вых                 макс. пад           уст. раб"
				formulaPat.draw(at: CGPoint(x: 98, y: 485), withAttributes: note)
				
				string = "= 2 * \(maxFallPresure) + \(reductor) = \(exitPString) \(value)"
				string.draw(at: CGPoint(x: 325, y: 478), withAttributes: large)
			} else {
				formulaPat = "P        = P            + P            /2 + P         "
				formulaPat.draw(at: CGPoint(x: 37, y: 478), withAttributes: bold)
				formulaPat = "к. вых         макс. пад         макс. пад                уст. раб"
				formulaPat.draw(at: CGPoint(x: 47, y: 485), withAttributes: note)
				
				string = "= \(maxFallPresure) + \(maxFallPresure)/2 + \(reductor) = \(exitPString) \(value)"
				string.draw(at: CGPoint(x: 344, y: 478), withAttributes: large)
			}
			
			if Parameters.shared.airSignalFlag {
				exitPString = Parameters.shared.measureType == .kgc ? String(Int(Parameters.shared.airSignal)) : String(format:"%.1f", floor(Parameters.shared.airSignal * 10) / 10)
				
				let signal = "\(exitPString) \(value)"
				signal.draw(at: CGPoint(x: 480, y: 514), withAttributes: large)
				//				SettingsData.airSignalFlag = false
			}
			
			// 4
			let someValue = Parameters.shared.airSignalFlag ? 36 : 0
			
			switch Parameters.shared.deviceType {
				case .air:
					string = "\(airRate) * K"
					string.draw(at: CGPoint(x: 180, y: 582+someValue), withAttributes: large)
					airIndexStr.draw(at: CGPoint(x: 228, y: 587+someValue), withAttributes: small)
					
					string = "\(airRate) * \(airIndex)"
					string.draw(at: CGPoint(x: 330, y: 582+someValue), withAttributes: large)
				
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 190, y: 582+someValue), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 350, y: 582+someValue), withAttributes: large)
			}
			string = "(\(minFirePressure) - \(exitPString)) * \(capacity)"
			string.draw(at: CGPoint(x: 304, y: 561+someValue), withAttributes: large)
			
			string = "= \(String(format:"%.1f", floor(workTime*10)/10)) ≈ \(Int(workTime)) мин."
			string.draw(at: CGPoint(x: 433, y: 571+someValue), withAttributes: large)
			
			// 5
			time.dateFormat = "HH"
			string = "\(time.string(from: Parameters.shared.fireTime))    +    = \(exitTime)"
			string.draw(at: CGPoint(x: 310, y: 686+someValue), withAttributes: large)
			
			time.dateFormat = "mm"
			string = "\(time.string(from: Parameters.shared.fireTime))     \(Int(workTime))"
			string.draw(at: CGPoint(x: 330, y: 681+someValue), withAttributes: small)
			
			// Имя файла PDF-шаблона
			let fileName = Parameters.shared.airSignalFlag ? "signal" : "airFoundNew"
			
			let path = Bundle.main.path(forResource: fileName, ofType: "pdf")!
			let url = URL(fileURLWithPath: path)
			let document = CGPDFDocument(url as CFURL)
			let page = document?.page(at: 1)
			UIColor.white.set()
			context.translateBy(x: 0.0, y: pageRect.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
			context.drawPDFPage(page!)
		}
		return data
	}
	
	
	// Метод генерирует лист А4 c расчетами если очаг пожара не найден.
	func notFoundPDFCreator() -> Data {
		// 1) Расчет максимального возможного падения давления при поиске очага
		let maxDrop = comp.maxDropCalculation(minPressure: Parameters.shared.enterPressureData, hardChoice: Parameters.shared.isHardWork)
		// 2) Расчет давления к выходу
		let exitPressure = comp.exitPressureCalculation(minPressure: Parameters.shared.enterPressureData, maxDrop: maxDrop)
		
		// 3) Расчет промежутка времени с вкл. до подачи команды дТ
		let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)
		
		// 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
		let exitTime = comp.expectedTimeCalculation(inputTime: Parameters.shared.startTime, totalTime: timeDelta)
		
		// Максимальное падение давления
		let maxDropString = Parameters.shared.measureType == .kgc ? (String(Int(maxDrop))) : (String(format:"%.1f", floor(maxDrop * 10) / 10))
		
		// Давление к выходу
		let exitPString = Parameters.shared.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", exitPressure))
	
		// Коэффициент, учитывающий необходимый запас воздуха
		var ratio: String
		// при сложных условиях = 3, при простых = 2.5
		Parameters.shared.isHardWork ? (ratio = "3") : (ratio = "2.5")
		
		PDFdataFormatter()
	
		// PDF
		let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
		let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
		
		let data = renderer.pdfData { (context) in
			context.beginPage()
			let context = context.cgContext
			var print: String
			// Координаты констант и вычисляемых значений на листе A4
			// 1
			print = "\(minEnterPressure) - \(reductor)"
			print.draw(at: CGPoint(x: 357, y: 205), withAttributes: large)
			
			ratio.draw(at: CGPoint(x: 255, y: 225), withAttributes: large)
			ratio.draw(at: CGPoint(x: 385, y: 225), withAttributes: large)
			
			print = "= \(maxDropString) \(value)"
			print.draw(at: CGPoint(x: 435, y: 215), withAttributes: large)
			
			// 2
			print = "\(minEnterPressure) - \(maxDropString) = \(exitPString) \(value)"
			print.draw(at: CGPoint(x: 350, y: 330), withAttributes: large)
			
			// 3
			switch Parameters.shared.deviceType {
				case .air:
					print = "\(airRate) * K                  \(airRate) * \(airIndex)"
					print.draw(at: CGPoint(x: 172, y: 485), withAttributes: large)
					airIndexStr.draw(at: CGPoint(x: 216, y: 492), withAttributes: small)
				
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 200, y: 485), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 310, y: 485), withAttributes: large)
				
			}
			print = "\(maxDropString) * \(capacity)"
			print.draw(at: CGPoint(x: 283, y: 465), withAttributes: large)
			
			print = "= \(String(format:"%.1f", floor(timeDelta * 10) / 10)) ≈ \(Int(timeDelta)) мин." //
			print.draw(at: CGPoint(x: 365, y: 475), withAttributes: large)
			
			//4
			let time = DateFormatter()
			time.dateFormat = "HH"
			print = "\(time.string(from: Parameters.shared.startTime))    +    = \(exitTime)"
			print.draw(at: CGPoint(x: 313, y: 590), withAttributes: large)
			
			time.dateFormat = "mm"
			time.string(from: Parameters.shared.startTime).draw(at: CGPoint(x: 333, y: 585), withAttributes: small)
			String(Int(timeDelta)).draw(at: CGPoint(x: 360, y: 585), withAttributes: small)
			
			// Подставляем PDF шаблон с формулами
			let path = Bundle.main.path(forResource: "airNotFoundNew", ofType: "pdf")!
			let url = URL(fileURLWithPath: path)
			let document = CGPDFDocument(url as CFURL)
			let page = document?.page(at: 1)
			UIColor.white.set()
			context.translateBy(x: 0.0, y: pageRect.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
			context.drawPDFPage(page!)
		}
		return data
	}
	
}
