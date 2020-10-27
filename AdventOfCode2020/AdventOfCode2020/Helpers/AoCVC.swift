//
//  AoCVC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import UIKit

protocol AdventDay {
    var numChallenges: Int { get }
    
    func loadInput()
    func solve(challenge: Int)
}

class AoCVC: UIViewController {
    private var solutionLabels: [UILabel] = []
    private var solutionButtons: [UIButton] = []

    private var solutionStartTimes: [Date] = []
    
    // DayXXInput
    var defaultInputFileString: String {
        return self.title!.appending("Input").replacingOccurrences(of: " ", with: "")
    }
    
    private var adventDay: AdventDay {
        guard let adventDay = self as? AdventDay else { fatalError("VC must conform to AdventDay protocol") }
        return adventDay
    }
    
    private var numChallenges: Int {
        return self.adventDay.numChallenges
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeTimers()
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadInput()
    }

    private func initializeTimers() {
        self.solutionStartTimes = Array<Date>(repeating: Date(), count: self.numChallenges)
    }

    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        let stackView = self.createStackView()
        self.view.addSubview(stackView)
        stackView.constrainToSuperView(leading: 40, trailing: 40, top: 20, bottom: 20, useSafeArea: true)
        
        for challenge in 0..<self.numChallenges {
            let button = self.createButton(challenge: challenge)
            self.solutionButtons.append(button)
            stackView.addArrangedSubview(button)
            
            let label = self.createLabel()
            label.isHidden = true
            self.solutionLabels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    
    private func loadInput() {
        let loadTime = Date()
        self.adventDay.loadInput()
        print("\(self.title!) input loaded in \(DateHelper.getElapsedTimeString(from: loadTime))")
    }

    func setSolution(challenge: Int, text: String) {
        guard challenge >= 0, challenge < self.solutionStartTimes.count else { fatalError("Invalid index.") }
        let timeString = DateHelper.getElapsedTimeString(from: self.solutionStartTimes[challenge])
        self.solutionButtons[challenge].isHidden = true
        self.solutionLabels[challenge].text = "\(text)\n\n\(timeString)"
        self.solutionLabels[challenge].isHidden = false
        print("\(self.title!) Solution \(challenge + 1): \(text) -- \(timeString)")
    }
    
    func setSolvable(challenge: Int, isSolvable: Bool) {
        guard challenge >= 0, challenge < self.solutionButtons.count else { fatalError("Invalid index.") }
        self.solutionButtons[challenge].isEnabled = isSolvable
    }
}

// UI creation
extension AoCVC {
    private func createButton(challenge: Int) -> UIButton {
        let button = UIButton(type: .system)
        let title = "Solve \(challenge + 1)"
        button.setTitle(title, for: .normal)
        button.tag = challenge
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        let index = sender.tag
        sender.isEnabled = false
        self.solutionStartTimes[index] = Date()
        self.adventDay.solve(challenge: index)
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        
        return stackView
    }
}
