//
//  AoCVC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import UIKit

protocol AdventDay {
    func loadInput()
    func solveFirst()
    func solveSecond()
}

class AoCVC: UIViewController {
    private var solution1Label: UILabel!
    private var solution2Label: UILabel!

    private var startTime = Date()
    private var solution1Time = Date()

    private var label: UILabel {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }
    
    var defaultInputFileString: String {
        return self.title?.replacingOccurrences(of: " ", with: "").appending("Input") ?? "N/A"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.constrainToSuperView(leading: 40, trailing: 40, top: 20, bottom: 20, useSafeArea: true)

        self.solution1Label = self.label
        self.solution2Label = self.label

        stackView.addArrangedSubview(self.solution1Label)
        stackView.addArrangedSubview(self.solution2Label)

        if let adventDay = self as? AdventDay {
            let loadTime = Date()
            adventDay.loadInput()
            print("\(self.title!) input loaded in \(self.getElapsedTimeString(from: loadTime))")
            self.startTime = Date()
            adventDay.solveFirst()
            adventDay.solveSecond()
        }
    }

    func setSolution1(_ text: String) {
        self.solution1Time = Date()
        let timeString = self.getElapsedTimeString(from: self.startTime)
        self.solution1Label.text = "\(text)\n\n\(timeString)"
        print("\(self.title!) Solution 1: \(text) -- \(timeString)")
    }

    func setSolution2(_ text: String) {
        let timeString = self.getElapsedTimeString(from: self.solution1Time)
        self.solution2Label.text = "\(text)\n\n\(timeString)"
        print("\(self.title!) Solution 2: \(text) -- \(timeString)")
    }

    private func getElapsedTimeString(from date: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(date)
        return String(format: "Time = %.4f", elapsedTime)
    }
}

