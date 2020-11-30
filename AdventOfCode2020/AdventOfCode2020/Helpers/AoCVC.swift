//
//  AoCVC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import UIKit

protocol AdventDay {
    func solveFirst()
    func solveSecond()
}

protocol InputLoadable {
    func loadInput()
}

protocol TestableDay {
    func runTests()
}

extension InputLoadable where Self: UIViewController {
    // DayXXInput
    var defaultInputFileString: String {
        return self.title!.appending("Input").replacingOccurrences(of: " ", with: "")
    }
}

class AoCVC: UIViewController {
    private var solutionLabels: [UILabel] = []
    private var solutionButtons: [UIButton] = []

    private var solutionStartTimes: [Date] = []
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var adventDay: AdventDay {
        guard let adventDay = self as? AdventDay else { fatalError("VC must conform to AdventDay protocol") }
        return adventDay
    }
    
    private var numChallenges = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeTimers()
        self.configureUI()
    }
    
    private var hasAppeared = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.hasAppeared {
            self.loadInput()
            self.runTests()
            self.enableButtons()
            self.hasAppeared = true
        }
    }
    
    private func enableButtons() {
        self.solutionButtons.forEach({$0.isEnabled = true})
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
        if let inputLoadable = self as? InputLoadable {
            let loadTime = Date()
            inputLoadable.loadInput()
            print("\(self.title!): Input loaded. \(DateHelper.getElapsedTimeString(from: loadTime))")
        }
    }
    
    private func runTests() {
        if let testableDay = self as? TestableDay {
            let testTime = Date()
            testableDay.runTests()
            print("\(self.title!): Tests OK. \(DateHelper.getElapsedTimeString(from: testTime))")
        }
    }

    func setSolution(challenge: Int, text: String) {
        guard challenge >= 0, challenge < self.solutionStartTimes.count else { fatalError("Invalid index.") }
        let timeString = DateHelper.getElapsedTimeString(from: self.solutionStartTimes[challenge])
        DispatchQueue.main.async {
            self.solutionButtons[challenge].isHidden = true
            self.solutionLabels[challenge].text = "\(text)\n\n\(timeString)"
            self.solutionLabels[challenge].isHidden = false
            print("\(self.title!) Solution \(challenge + 1): \(text) -- \(timeString)")
        }
    }
}

// UI creation
extension AoCVC {
    private func createButton(challenge: Int) -> UIButton {
        let button = UIButton(type: .system)
        let title = "Solve \(challenge + 1)"
        button.setTitle(title, for: .normal)
        button.setTitle("Initialization...", for: .disabled)
        button.setTitle("Solving...", for: .highlighted)
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
        sender.setTitle("Solving...", for: .disabled)
        let tag = sender.tag
        DispatchQueue.global(qos: .userInitiated).async {
            self.solutionStartTimes[index] = Date()
            switch tag {
            case 0:
                self.adventDay.solveFirst()
            case 1:
                self.adventDay.solveSecond()
            default:
                fatalError("Invalid button index.")
            }
        }
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
