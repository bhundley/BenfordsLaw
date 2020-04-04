//
//  ViewController.swift
//  ProntoChallenge
//
//  Created by Byron Hundley on 4/2/20.
//  Copyright © 2020 Noryb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var sampleSizeCountLabel: UILabel!
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    var graphData = [Int: Int]()
    var stateData: [StateData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        selectButton(type: .total)
        
        // Grab the data for the calculation
        DataRequestManager.shared.getData {[weak self] data in
            self?.stateData = data
            self?.setDataSource(forType: .total)
            
            DispatchQueue.main.async {
                self?.sampleSizeCountLabel.text = String(data.count)
                self?.drawBarGraph()
            }
        }
    }
    
    // MARK: Button Styles
    func setupButtons() {
        totalButton.layer.cornerRadius = 6.0
        positiveButton.layer.cornerRadius = 6.0
        negativeButton.layer.cornerRadius = 6.0
    }
    
    func selectButton(type: ResultType) {
        // Reset the button colors
        totalButton.backgroundColor = .lightGray
        positiveButton.backgroundColor = .lightGray
        negativeButton.backgroundColor = .lightGray
        
        // Highlight the selected one.
        switch type {
        case .total:
            totalButton.backgroundColor = .systemTeal
        case .positive:
            positiveButton.backgroundColor = .systemTeal
        case .negative:
            negativeButton.backgroundColor = .systemTeal
        }
    }
    
    // MARK: IBActions
    @IBAction func positiveButtonPressed(_ sender: Any) {
        selectButton(type: .positive)
        setDataSource(forType: .positive)
        drawBarGraph()
    }
    
    @IBAction func negativeButtonPressed(_ sender: Any) {
        selectButton(type: .negative)
        setDataSource(forType: .negative)
        drawBarGraph()
    }
    
    @IBAction func totalButtonPressed(_ sender: Any) {
        selectButton(type: .total)
        setDataSource(forType: .total)
        drawBarGraph()
    }
}
