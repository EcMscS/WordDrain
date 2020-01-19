//
//  WordContainerView.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/9/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class WordContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemPink
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }

}
