//
//  HMSelectGameButton.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/24/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class HMSelectGameButton: UIButton {

    var buttonTitle: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonTitle = "TITLE"
        configure()
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.buttonTitle = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        titleLabel?.textAlignment = .center
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.label, for: .normal)
        layer.cornerRadius = 10
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 2
        backgroundColor = .systemYellow
        translatesAutoresizingMaskIntoConstraints = false
    }

}
