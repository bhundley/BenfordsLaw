//
//  BarGraph+ViewController.swift
//  ProntoChallenge
//
//  Created by Byron Hundley on 4/4/20.
//  Copyright © 2020 Noryb. All rights reserved.
//

import UIKit
import Foundation

extension ViewController {
    func setDataSource(forType type: ResultType) {
        graphData = stateData.reduce(into: [Int: Int]()) {(count, stateData) in
            var number = 0
            
            // Get the data set for the selected results type
            switch type {
            case .total:
                number = stateData.totalTestResults
            case .positive:
                number = stateData.positive
            case .negative:
                number = stateData.negative
            }
            
            // Get the first digit of the specified number
            // Keep track of how many times the digits appears in set
            if let first = String(number).first, let index = Int(String(first)) {
                count[index, default: 0] += 1
            }
            
            // A check to see if the negative and positive results equals the total
            // They appear to equal totalTestResults but not total
//            if stateData.negative + stateData.positive == stateData.totalTestResults {
//                print("State: \(stateData.state) ✅")
//            }
//            else {
//                print("State: \(stateData.state) ❌")
//            }
        }
    }
    
    func drawBarGraph() {
        // Clean up the graph before redrawing
        graphStackView.arrangedSubviews.forEach { arrangedView in
            NSLayoutConstraint.deactivate(arrangedView.constraints)
            graphStackView.removeArrangedSubview(arrangedView)
            
            arrangedView.subviews.forEach { subView in
                NSLayoutConstraint.deactivate(subView.constraints)
                graphStackView.removeArrangedSubview(subView)
            }
        }
            
        // Add each bar and labels for the graph
        (1...9).forEach { index in
            let count = graphData.first(where: {$0.key == index})?.value ?? 0
            
            let bar = UIView()
            let colorRange = (CGFloat(index) * 22.0) / 255.0
            bar.backgroundColor = UIColor.init(red: 0.95, green: colorRange, blue: colorRange, alpha: 1.0)
            
            // Label for the graph first digit categories
            let keyLabel = UILabel()
            keyLabel.text = String(index)
            keyLabel.textAlignment = .center
            keyLabel.textColor = .secondaryLabel
            bar.addSubview(keyLabel)
            
            // Label for number of occurances
            let valueLabel = UILabel()
            valueLabel.text = count > 0 ? String(count) : ""
            valueLabel.textAlignment = .center
            valueLabel.textColor = .secondaryLabel
            bar.addSubview(valueLabel)
            
            bar.translatesAutoresizingMaskIntoConstraints = false
            keyLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Activate auto layout constraints
            NSLayoutConstraint.activate([
                bar.heightAnchor.constraint(equalToConstant: CGFloat(count * 10)),
                keyLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor),
                keyLabel.bottomAnchor.constraint(equalTo: bar.bottomAnchor, constant: 24),
                valueLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor),
                valueLabel.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -4)
            ])
            
            // Add to the stackview
            graphStackView.addArrangedSubview(bar)
        }
        
        // Layout now so we have the bar heights for animation
        view.layoutIfNeeded()
        
        // Animate the bars in
        graphStackView.arrangedSubviews.forEach { bar in
            let heightConstant = bar.frame.height
            var heightConstraint: NSLayoutConstraint?
            
            // Reset the constraint height to zero
            if let constraint = bar.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint = constraint
                heightConstraint?.constant = 0
                view.layoutIfNeeded()
            }
            
            // Animate back to original height
            heightConstraint?.constant = heightConstant
            
            UIView.animate(withDuration: 0.6,
                           delay: 0.1,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 2.0,
                           options: .curveEaseIn,
                           animations: ({ [weak self] in
                                self?.view.layoutIfNeeded()
                           }),
                           completion: nil)
        }
    }
}
