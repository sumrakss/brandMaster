//
//  PDFPreviewViewController.swift
//  FireCalculator
//
//  Created by Алексей on 01.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewScreen: UIViewController {

    // MARK: - IBOutlets
    
	@IBOutlet weak var pdfView: PDFView!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	
    
     // MARK: - Public Properties
    
    public var documentData: Data?
	
	
     // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPDF()
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Разрешаем любую ориентацию для отображения PDF-файла с решением
//		atencionMessage()
//		AppDelegate.AppUtility.lockOrientation(.all)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
//		AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
	}

	
      // MARK: - Private Methods
    
    private func createPDF() {
		if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
    }
    
}
