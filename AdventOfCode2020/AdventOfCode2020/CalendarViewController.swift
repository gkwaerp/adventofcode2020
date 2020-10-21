//
//  CalendarViewController.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import UIKit

class CalendarViewController: UIViewController {
    private let mainStackView = UIStackView()
    private var subStackViews = [UIStackView]()

    private let verticalSpacing: CGFloat = 4
    private let horizontalSpacing: CGFloat = 16
    
    //Days start at 1, not 0.
    private var calendarDays: [Int: UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advent of Code 2020"
        
        self.configureStackViews()
        self.configureButtons()
    }
    
    private func configureStackViews() {
        self.mainStackView.axis = .horizontal
        self.mainStackView.distribution = .fillEqually
        self.mainStackView.alignment = .center
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.spacing = self.horizontalSpacing
        self.view.addSubview(self.mainStackView)
        
        NSLayoutConstraint.activate([self.mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
        for _ in 0..<4 {
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.distribution = .fillEqually
            subStackView.alignment = .center
            subStackView.spacing = self.verticalSpacing
            self.mainStackView.addArrangedSubview(subStackView)
            self.subStackViews.append(subStackView)
        }
    }

    private func makeAdventDayButton(day: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let dayString = String(format: "%02d", day)
        button.setTitle("Day \(dayString)", for: .normal)
        button.tag = day
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.isEnabled = (self.calendarDays[day] != nil)
        return button
    }
    
    private func configureButtons() {
        for i in 0..<24 {
            let day = i + 1
            let stackViewIndex = i % 4
            self.subStackViews[stackViewIndex].addArrangedSubview(self.makeAdventDayButton(day: day))
        }
        
        let sillyButton = self.makeAdventDayButton(day: 25)
        self.view.addSubview(sillyButton)
        NSLayoutConstraint.activate([sillyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     sillyButton.topAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: self.verticalSpacing)])
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        if let vc = self.calendarDays[sender.tag] {
            vc.modalPresentationStyle = .overFullScreen
            vc.title = String(format: "Day %02d", sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
