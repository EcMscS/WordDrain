//
//  ScorecardVC.swift
//  Hangman
//
//  Created by Jeffrey Lai on 12/10/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit

class ScorecardVC: UIViewController {

    var gameResultLabel: UILabel = UILabel()
    var scoreLabel: UILabel = UILabel()
    var levelCompletedLabel: UILabel = UILabel()
    var gameStatus: UILabel = UILabel()
    
    let newGameButton: UIButton = UIButton()
    let resultsStackview: UIStackView = UIStackView()
    
    init(gameResult: String, score: Int, levelCompleted: Bool) {
        super.init(nibName: nil, bundle: nil)
        gameResultLabel.text = gameResult
        scoreLabel.text = "Score: \(score)"
        if levelCompleted == false {
            newGameButton.setTitle("New Game", for: .normal)
        } else {
            newGameButton.setTitle("Next Level", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    
}
