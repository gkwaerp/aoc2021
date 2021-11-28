//
//  MainViewController.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: Variables
    private let calendarDays: Set<Int> = [1]
    
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
        let stackViews = (0..<4).map( { _ -> UIStackView in
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
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
    
    @objc private func didTapButton(sender: UIButton) {
        let vcName = String(format: "Day%02dVC", sender.tag)
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { fatalError() }
        let sanitizedName = appName.replacingOccurrences(of: " ", with: "_")
        guard let vcType = NSClassFromString("\(sanitizedName).\(vcName)") as? UIViewController.Type else { fatalError() }
        let vc = vcType.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}

