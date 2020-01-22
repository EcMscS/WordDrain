//
//  ScorecardVC.swift
//  Hangman
//
//  Created by Jeffrey Lai on 12/10/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit

protocol ScorecardVCDelegate: AnyObject {
    func startNewGame()
}

class ScorecardVC: UIViewController {
    
    var containerView: UIView = UIView()
    var gameResultLabel: UILabel = UILabel()
    var levelCompletedLabel: UILabel = UILabel()
    var scoreLabel: UILabel = UILabel()
    var gameStatus = HMGameEndState.win
    
    let newGameButton = UIButton()
    let nextLevelButton: UIButton = UIButton()
    //let resultsStackview: UIStackView = UIStackView()
    
    let textHeight: CGFloat = 40
    
    weak var delegate: ScorecardVCDelegate?
    
    var score = 0 {
            didSet {
                scoreLabel.text = "Score: \(score)"
            }
        }
    
    init(score: Int, gameStatus: HMGameEndState, levelCompleted: Bool, level: Int) {
        super.init(nibName: nil, bundle: nil)
       
        self.gameStatus = gameStatus
        if gameStatus == .win {
            gameResultLabel.textColor = .systemGreen
            gameResultLabel.text = "You Win"
        } else {
            gameResultLabel.textColor = .systemRed
            gameResultLabel.text = "You Lose"
        }
        
        self.scoreLabel.text = "Score: \(score)"
        
        self.newGameButton.setTitle("New Game", for: .normal)
        self.nextLevelButton.setTitle("Next Level", for: .normal)
        self.levelCompletedLabel.text = "Level \(level) Completed"
        
        if levelCompleted {
            newGameButton.isHidden = true
            nextLevelButton.isHidden = false
            levelCompletedLabel.isHidden = false
        } else {
            newGameButton.isHidden = false
            nextLevelButton.isHidden = true
            levelCompletedLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureNewGameButton()
        configureGameResultLabel()
        configureScoreLabel()
        configureNextLevelButton()
        configureLevelCompletedLabel()
    }
    
    private func configureLevelCompletedLabel() {
        containerView.addSubview(levelCompletedLabel)
        levelCompletedLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        levelCompletedLabel.adjustsFontSizeToFitWidth = true
        levelCompletedLabel.textAlignment = .center
        levelCompletedLabel.textColor = .systemOrange
        levelCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            levelCompletedLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            levelCompletedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            levelCompletedLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            levelCompletedLabel.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
    
    private func configureNextLevelButton() {
        containerView.addSubview(nextLevelButton)
        nextLevelButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        nextLevelButton.backgroundColor = .systemPurple
        nextLevelButton.setTitleColor(.label, for: .normal)
        nextLevelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextLevelButton.layer.borderColor = UIColor.white.cgColor
        nextLevelButton.layer.borderWidth = 2
        nextLevelButton.layer.cornerRadius = 20
        nextLevelButton.translatesAutoresizingMaskIntoConstraints = false
        nextLevelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nextLevelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25),
            nextLevelButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nextLevelButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            nextLevelButton.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
    
    private func configureGameResultLabel() {
        containerView.addSubview(gameResultLabel)
        gameResultLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        gameResultLabel.adjustsFontSizeToFitWidth = true
        gameResultLabel.textAlignment = .center
        gameResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameResultLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            gameResultLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            gameResultLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            gameResultLabel.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
    
    private func configureNewGameButton() {
        containerView.addSubview(newGameButton)
        newGameButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        newGameButton.backgroundColor = .systemPurple
        newGameButton.setTitleColor(.label, for: .normal)
        newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        newGameButton.layer.borderColor = UIColor.white.cgColor
        newGameButton.layer.borderWidth = 2
        newGameButton.layer.cornerRadius = 20
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    
        NSLayoutConstraint.activate([
            newGameButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25),
            newGameButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            newGameButton.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
    
    private func configureScoreLabel() {
        containerView.addSubview(scoreLabel)
        scoreLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: gameResultLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            scoreLabel.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .systemYellow
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
    }
    
    @objc func dismissVC() {
        delegate?.startNewGame()
        dismiss(animated: true)
    }
    
}
