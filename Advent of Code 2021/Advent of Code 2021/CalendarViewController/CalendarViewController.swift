//
//  CalendarViewController.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import UIKit

class CalendarViewController: UIViewController {
    // MARK: Variables
    private let calendarDays: Set<Int> = []
    
    // MARK: UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private let subStackViews: [UIStackView] = {
        let stackViews: [UIStackView] = (0..<4).map( { _ in
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            return stackView
        })
        return stackViews
    }()
    
    private func createButton(for day: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = String(format: "%2d", day)
        button.setTitle(title, for: .normal)
        button.tag = day
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.isEnabled = calendarDays.contains(day)
        return button
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Advent of Code 2021"
        
        setupUI()
    }
    
    // MARK: UI Helpers
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainStackView)
        subStackViews.forEach { subStackView in
            mainStackView.addArrangedSubview(subStackView)
        }
        
        for i in 0..<24 {
            let day = i + 1
            let stackViewIndex = i % 4
            self.subStackViews[stackViewIndex].addArrangedSubview(createButton(for: day))
        }
        
        let lastDay = self.createButton(for: 25)
        view.addSubview(lastDay)
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            lastDay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastDay.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 0)
        ])
    }
    
    @objc private func buttonPressed(sender: UIButton) {
        let dayString = String(format: "Day%02dVC", sender.tag)
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { fatalError("No bundle name found!") }
        
        let sanitizedName = appName.replacingOccurrences(of: " ", with: "_")
        let vcName = "\(sanitizedName).\(dayString)"
        guard let vcType = NSClassFromString(vcName) as? UIViewController.Type else { fatalError("No VC matching name '\(vcName)'") }
        
        let vc = vcType.init()
        vc.title = String(format: "Day %02d", sender.tag)
        navigationController?.pushViewController(vc, animated: true)
    }
}

