//
//  HMLettersContainerView.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/10/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

protocol HMLettersContinerViewDelegate: AnyObject {
    func letterButtonPressed(letter: UIButton)
}

class HMLettersContainerView: UIView {

    let numberOfRows = 6
    let numberOfLettersInEachRow = 5
    
    var allLetters: [Character] = []
    var usedLetters: [Character] = []
    var alphabetButtons: [UIButton] = [UIButton]()
    
    let letterColumnStackview: UIStackView = UIStackView()
    var letterRowStackviews = [UIStackView]()

    weak var delegate: HMLettersContinerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func emptyButtonsAndLetters() {
        let alphabet = "abcdefghijklmnopqrstuvwxyz".uppercased() //26 Letters
        
        allLetters = [Character]()
        
        for (position, letter) in alphabet.enumerated() {
            allLetters.append(letter)
            let newButton = UIButton(type: .system)
            newButton.tag = position
            alphabetButtons.append(newButton)
        }
    }
    
    func setupLetters() {
        for _ in 0..<numberOfRows {
            let singleStackview = UIStackView()
            singleStackview.translatesAutoresizingMaskIntoConstraints = false
            singleStackview.distribution = .fillEqually
            singleStackview.axis = .horizontal
            letterRowStackviews.append(singleStackview)
        }
        
        letterColumnStackview.translatesAutoresizingMaskIntoConstraints = false
        letterColumnStackview.distribution = .fillEqually
        letterColumnStackview.axis = .vertical
        
        var index = 0
        
        for each in 0..<letterRowStackviews.count {
            letterColumnStackview.addArrangedSubview(letterRowStackviews[each])
            for _ in 0..<numberOfLettersInEachRow {
                if !allLetters.isEmpty {
                    let button = alphabetButtons[index]
                    let currentLetter = allLetters.removeFirst()
            
                    let letterAttribute = createAttributedText(word: String(currentLetter))
                    button.setAttributedTitle(letterAttribute, for: .normal)
                    letterRowStackviews[each].addArrangedSubview(button)
                    button.addTarget(self, action:#selector(buttonPressed(button:)), for: .touchUpInside)
                    
                    index += 1
                    
                    //TESTING
                    print("CONTAINERVIEW: Current Letter: \(currentLetter) and letter count: \(allLetters.count)" )
                }
            }
        }
        
        self.addSubview(letterColumnStackview)
        
        NSLayoutConstraint.activate([
            letterColumnStackview.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            letterColumnStackview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            letterColumnStackview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            letterColumnStackview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }
    
    func resetLetters() {
        allLetters.removeAll()
        usedLetters.removeAll()
        
        //Reset Buttons
        for eachButton in alphabetButtons {
            eachButton.isEnabled = true
            eachButton.alpha = 1.0
        }
    }
    
    @objc func buttonPressed(button: UIButton) {
        delegate?.letterButtonPressed(letter: button)
        
        let aLetter = (button.currentAttributedTitle)?.string
        usedLetters.append(Character(aLetter!))
        
        //Change appearance of pressed button
        button.isEnabled = false
        button.alpha = 0.3
    }
    
    private func createAttributedText(word: String) -> NSAttributedString {
        
        let labelFont = UIFont.preferredFont(forTextStyle: .title1)
        var fontAttributes: [NSAttributedString.Key: Any]
        
        fontAttributes = [
            .font: labelFont,
            .foregroundColor: UIColor.label
        ]
        
        return NSAttributedString.init(string: word, attributes: fontAttributes)
    }
}
