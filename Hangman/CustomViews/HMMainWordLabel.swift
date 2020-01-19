//
//  HMMainWordLabel.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/9/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class HMMainWordLabel: UILabel {

    let wordSpacing: Int = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, word: String) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.attributedText = createAttributedText(word: word)
        configure()
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createAttributedText(word: String) -> NSAttributedString {
        
        let labelFont = UIFont.preferredFont(forTextStyle: .headline)
        var fontAttributes: [NSAttributedString.Key: Any]
        
        fontAttributes = [
            .font: labelFont,
            .foregroundColor: UIColor.label,
            .kern: wordSpacing
        ]
        
        return NSAttributedString.init(string: word, attributes: fontAttributes)
    }

}
