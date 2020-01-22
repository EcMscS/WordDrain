//
//  MainVC.swift
//  Hangman
//
//  Created by Jeffrey Lai on 11/27/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    let allowedNumberOfGuesses = 7
    
    let navBarLabel: UILabel = UILabel()
    var wordLabel: HMMainWordLabel!
    let wordView = WordContainerView()
    let batteryView = HMBatteryContainerView()
    let scoreCardVC: ScorecardVC? = nil

    let lettersView = HMLettersContainerView()
    
    var gameState:HMGameEndState?
    var score = 0
    
    var currentPosition: Int = 0
    var level = 1
    var wordList: [String] = [String]()
    var currentGameWord: String = ""
    var correctWordCount: Int = 0
    var incorrectGuessCount: Int = 0
    var currentGuess: [String] = [String]()
    var currentWord: String = ""
    var gameCompleted: Bool = false
    var levelCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        loadLevel()
        setupNavBar()
        configureWordContainerView()
        configureBatteryContainerView()
        configureLettersContainerView()
        setupGame(newWord: currentGameWord)
      
        lettersView.setupLetters()
        lettersView.delegate = self
    }

    
    func setupGame(newWord: String) {
        currentWord = newWord.uppercased()
        print("Current word is: \(currentWord)")
        
        currentGuess.removeAll()
        
        for (_,_) in currentWord.enumerated() {
            currentGuess.append("_")
        }
        
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.attributedText = createAttributedText(text: numberOfUnderscores(), size: 30, fontWeight: .heavy, isShadow: false, wordSpacing: 4, textColor: .label)
        
        gameCompleted = false
        lettersView.emptyButtonsAndLetters()
    }
    
    func setupNavBar() {
        navBarLabel.text = "H?NGM?N"
        navBarLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        navBarLabel.font = .boldSystemFont(ofSize: 50)
        navBarLabel.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = navBarLabel

        navigationController?.navigationBar.tintColor = .systemRed
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func configureBatteryContainerView() {
        view.addSubview(batteryView)
        
        let batterySize = batteryView.getBatterySize()
        
        NSLayoutConstraint.activate([
            batteryView.topAnchor.constraint(equalTo: wordView.bottomAnchor, constant: 10),
            batteryView.widthAnchor.constraint(equalToConstant: batterySize.width),
            batteryView.heightAnchor.constraint(equalToConstant: batterySize.height),
            batteryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func configureWordContainerView() {
        wordLabel = HMMainWordLabel.init(textAlignment: .center, word: numberOfUnderscores())
        
        wordView.addSubview(wordLabel)
        view.addSubview(wordView)
        
        NSLayoutConstraint.activate([
            wordLabel.centerYAnchor.constraint(equalTo: wordView.centerYAnchor),
            wordLabel.centerXAnchor.constraint(equalTo: wordView.centerXAnchor),
            
            wordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            wordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            wordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            wordView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func configureLettersContainerView() {
        view.addSubview(lettersView)
        
        NSLayoutConstraint.activate([
            lettersView.topAnchor.constraint(equalTo: batteryView.bottomAnchor, constant: 10),
            lettersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lettersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lettersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    //Only to be called when game is reset
    func numberOfUnderscores() -> String {
        let number = currentWord.count
        var underscores:String = ""
    
        for _ in 0..<number {
            underscores = underscores + "_"
        }
        
        return underscores
    }
    
    func loadLevel() {
        
        wordList.removeAll()
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") {
                
                if let levelWords = try? String(contentsOf: levelFileURL) {
                    var lines = levelWords.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (_, word) in lines.enumerated() {
                        if word != "" {
                            print("Added \(word) to wordlist ")
                            self.wordList.append(word)
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.currentPosition = 0
            self.currentWord = self.wordList[self.currentPosition]
            self.setupGame(newWord: self.currentWord)
           
            if self.currentPosition == self.wordList.count - 1 {
                self.levelCompleted = true
            } else {
                self.levelCompleted = false
            }
        }
    }
    
    func nextWord() {
        let count = wordList.count - 1
        if currentPosition == count {
            levelCompleted = true
            self.level += 1
            setupScoreCardView()
            loadLevel()
        } else {
            print("Current position is \(currentPosition)")
            currentPosition += 1
            currentWord = wordList[currentPosition]
        }
    }
    
    func nextLevel() {
        
    }
    
    func createAttributedText(text: String, size: CGFloat, fontWeight: UIFont.Weight , isShadow: Bool, wordSpacing: CGFloat, textColor: UIColor) -> NSAttributedString {
        let buttonFont = UIFont.systemFont(ofSize: size, weight: fontWeight)
        var fontAttributes: [NSAttributedString.Key: Any]
        
        if isShadow {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowBlurRadius = 2
            
            fontAttributes = [
                .font: buttonFont,
                .foregroundColor: textColor,
                .shadow: shadow,
                .kern: wordSpacing
            ]
        } else {
            fontAttributes = [
                .font: buttonFont,
                .foregroundColor: textColor,
                .kern: wordSpacing
            ]
        }
        return NSAttributedString.init(string: text, attributes: fontAttributes)
    }
    
    func revealLetter(letter: String) {
        var revealPositions = [Int]()
        
        for (position, eachLetter) in currentWord.enumerated() {
            if eachLetter == Character(letter) {
                revealPositions.append(position)
            }
        }
        
        while revealPositions.count != 0 {
            for reveal in revealPositions {
                currentGuess[reveal] = letter
                wordLabel.attributedText = createAttributedText(text: currentGuess.joined(), size: 30, fontWeight: .heavy, isShadow: false, wordSpacing: 10, textColor: .label)
            }
            if !revealPositions.isEmpty {
                revealPositions.remove(at: 0)
                correctWordCount += 1
            }
        }
    }
    
    func setupScoreCardView() {
        guard let state = gameState else { return }
        
        let newScoreCard = ScorecardVC(score: score, gameStatus: state, levelCompleted: levelCompleted, level: level)
        newScoreCard.modalPresentationStyle = .overFullScreen
        newScoreCard.modalTransitionStyle = .coverVertical
        newScoreCard.delegate = self
        present(newScoreCard, animated: true)
    }
    
    func resetButtons() {
        currentGuess.removeAll()
        correctWordCount = 0
        incorrectGuessCount = 0
 
        batteryView.resetBattery()
        lettersView.resetLetters()
    }
    
    func endGame(state: HMGameEndState) {
        if state == .win {
            if incorrectGuessCount == 0 {
                score += 5
            } else if incorrectGuessCount >= 1 && incorrectGuessCount <= 3 {
                score += 3
            } else if incorrectGuessCount >= 4 &&
                incorrectGuessCount < 6 {
                score += 2
            } else if incorrectGuessCount >= 6 {
                score += 1
            }
            
            gameState = .win
        } else if state == .lose {
            score -= 5
            gameState = .lose
        }
        
        setupScoreCardView()
    }
}

extension MainVC: HMLettersContinerViewDelegate {
    func letterButtonPressed(letter: UIButton) {
        guard let aLetter = (letter.currentAttributedTitle)?.string else {
            return
        }
        
        if currentWord.contains(aLetter) {
            revealLetter(letter: aLetter)
            
            if correctWordCount == currentWord.count {
                endGame(state: .win)
            }
        } else {
            incorrectGuessCount += 1
            batteryView.reduceBattery(multiple: incorrectGuessCount)
            
            if allowedNumberOfGuesses == incorrectGuessCount {
                endGame(state: .lose)
            }
        }
    }
}

extension MainVC: ScorecardVCDelegate {
    func startNewGame() {
        if levelCompleted == true {
            print("Implement Next Level")
            resetButtons()
            nextWord()
            setupGame(newWord: currentWord)
            levelCompleted = false
        } else {
            nextWord()
            resetButtons()
            setupGame(newWord: currentWord)
        }
    }
}
