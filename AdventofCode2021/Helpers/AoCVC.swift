//
//  AoCVC.swift
//  AdventofCode2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation
import UIKit


class AoCVC: UIViewController {
    // MARK: Variables
    private let numChallenges = 2
    
    private var solutionLabels: [UILabel] = []
    private var solutionButtons: [UIButton] = []
    private var solutionStartTimes: [Date] = []
    
    var defaultInputFileString: String {
        guard let title = title else { fatalError("VC does not have title.") }
        return title.appending("Input").replacingOccurrences(of: " ", with: "")
    }
    
    private var hasAppeared = false
    
    private var adventDay: AdventDay {
        guard let ad = self as? AdventDay else { fatalError("VC does not conform to AdventDay.") }
        return ad
    }
    
    // MARK: UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func createButton(for challenge: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = "Solve \(challenge + 1)"
        button.setTitle(title, for: .normal)
        button.setTitle("Initialization...", for: .disabled)
        button.setTitle("Solving...", for: .highlighted)
        button.tag = challenge
        button.addTarget(self, action: #selector(solutionButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }
    
    private func createSolutionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTimers()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasAppeared {
            loadInput()
            runTests()
            enableButtons()
            hasAppeared = true
        }
    }
    
    // MARK: UI Helpers
    private func initializeTimers() {
        self.solutionStartTimes = Array<Date>(repeating: Date(), count: numChallenges)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(stackView)
        stackView.constrainToSuperView(top: 20, leading: 40, trailing: 40, bottom: 20, useSafeArea: true)
        
        for challenge in 0..<numChallenges {
            let button = self.createButton(for: challenge)
            self.solutionButtons.append(button)
            stackView.addArrangedSubview(button)
            
            let label = self.createSolutionLabel()
            self.solutionLabels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    
    @objc private func solutionButtonTapped(sender: UIButton) {
        let index = sender.tag
        sender.isEnabled = false
        sender.setTitle("Solving...", for: .disabled)
        let tag = sender.tag
        DispatchQueue.global(qos: .userInitiated).async {
            self.solutionStartTimes[index] = Date()
            switch tag {
            case 0:
                let answer = self.adventDay.solvePart1()
                self.setSolution(challenge: index, answer: answer)
            case 1:
                let answer = self.adventDay.solvePart2()
                self.setSolution(challenge: index, answer: answer)
            default:
                fatalError("Invalid button index.")
            }
        }
    }
    
    private func setSolution(challenge: Int, answer: String) {
        guard (0..<numChallenges).contains(challenge) else { fatalError("Invalid index.") }
        let timeString = DateHelper.getElapsedTimeString(from: self.solutionStartTimes[challenge])
        DispatchQueue.main.async {
            self.solutionButtons[challenge].isHidden = true
            self.solutionLabels[challenge].text = "\(answer)\n\n\(timeString)"
            self.solutionLabels[challenge].isHidden = false
            print("Solution \(challenge + 1): \(answer) -- \(timeString)")
        }
    }
    
    // MARK: Misc
    private func loadInput() {
        let loadTime = Date()
        adventDay.loadInput()
        print("Input loading complete. Time = \(DateHelper.getElapsedTimeString(from: loadTime))")
    }
    
    private func runTests() {
        let testTime = Date()
        adventDay.doTests()
        print("Tests complete. Time: \(DateHelper.getElapsedTimeString(from: testTime))")
    }
    
    private func enableButtons() {
        solutionButtons.forEach({$0.isEnabled = true})
    }
}
