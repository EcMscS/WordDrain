//
//  HMCustomBackgroundView.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/24/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class HMCustomBackgroundView: UIView {

    var listOfWords = ["Apple", "Doppelganger", "aforetime", "Yeet", "Adamant", "Serendipity", "Butterfly", "Tailor", "Rue", "Inconspicuous", "Swift", "Coffee", "Destitute"]
    var listOfLabels = [UILabel]()
    
    var containerHeight: CGFloat = 0
    var containerWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        createList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerHeight = self.frame.height
        containerWidth = self.frame.width
        initializePostiionOfWords()
    }
    
    func initializePostiionOfWords() {
        for eachLabel in listOfLabels {
            self.addSubview(eachLabel)
            eachLabel.translatesAutoresizingMaskIntoConstraints = false
            eachLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            eachLabel.alpha = 0.0
            eachLabel.textColor = UIColor(red: randomNumber(max: 256)/255, green: randomNumber(max: 256)/255, blue: randomNumber(max: 256)/255, alpha: 1.0)

            NSLayoutConstraint.activate([
                eachLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: randomNumber(max: containerHeight - 30)),
                eachLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -containerWidth)
            ])
        }
    }
    
    func animateWords() {
        print("Start Animation with \(listOfLabels.count)")
        for eachLabel in listOfLabels {
            UIView.animate(withDuration: randomNumber(min: 8, max: 20), delay: randomNumber(min: 0, max: 8), options: .repeat, animations: {
                eachLabel.center.x += self.frame.width * 2
                eachLabel.alpha = 1.0
            }, completion: { _ in
                eachLabel.alpha = 0.0
            })
        }
    }
    
    private func createList() {
        for eachWord in listOfWords {
            let newWord = UILabel()
            newWord.text = eachWord
            newWord.adjustsFontSizeToFitWidth = true
            newWord.font = UIFont.preferredFont(forTextStyle: .largeTitle)
            newWord.alpha = 0.5
            listOfLabels.append(newWord)
        }
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func randomNumber(max: CGFloat) -> CGFloat {
        return CGFloat.random(in: 0..<max)
    }
    
    private func randomNumber(min: Double, max: Double) -> Double {
        return Double.random(in: min..<max)
    }
}
