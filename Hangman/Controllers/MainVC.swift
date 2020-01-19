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
    
    enum GameEndState {
        case win
        case lose
    }
    
    let navBarLabel: UILabel = UILabel()
    var wordLabel: HMMainWordLabel!
    let wordView = WordContainerView()
    let batteryView = HMBatteryContainerView()
    
    var scoreLabel: UILabel = UILabel()
    let newGameButton: UIButton = UIButton(type: .system)
    let scoreCardView: UIView = UIView()
    var levelCompletedLabel: UILabel = UILabel()
   
    var gameStatus: UILabel = UILabel()

    let lettersView = HMLettersContainerView()
    
    var score = 0 {
        didSet {
            scoreLabel.attributedText = createAttributedText(text: "Score: \(score)", size: 40, fontWeight: .semibold, isShadow: false, wordSpacing: 0, textColor: .label)
        }
    }
    
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

    var scorecardTopAnchor: NSLayoutConstraint!
    var scorecardTrailingAnchor: NSLayoutConstraint!
    var scorecardBottomAnchor: NSLayoutConstraint!
    var scorecardLeadingAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loadLevel()
        setupNavBar()
        configureWordContainerView()
        configureBatteryContainerView()
        configureLettersContainerView()
        setupViews()
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
    
    //Only called once
    func setupViews() {
        setupGame(newWord: currentGameWord)
        
        scoreCardView.backgroundColor = .systemYellow
        scoreCardView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scoreCardView)

        scorecardTopAnchor = scoreCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        scorecardTrailingAnchor = scoreCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        scorecardLeadingAnchor = scoreCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        scorecardBottomAnchor = scoreCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            scorecardTopAnchor,
            scorecardTrailingAnchor,
            scorecardBottomAnchor,
            scorecardLeadingAnchor
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
            setupScorecardView()
            loadLevel()
        } else {
            print("Current position is \(currentPosition): Next Word")
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
    
    func setupScorecardView() {
        print("Setup scorecard views")
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameStatus.textAlignment = .center
        gameStatus.translatesAutoresizingMaskIntoConstraints = false
        
        levelCompletedLabel.textAlignment = .center
        levelCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if levelCompleted == true {
            newGameButton.setAttributedTitle(createAttributedText(text: "Next Level", size: 30, fontWeight: .medium, isShadow: false, wordSpacing: 0, textColor: .label), for: .normal)
        } else {
            newGameButton.setAttributedTitle(createAttributedText(text: "Next Word", size: 30, fontWeight: .medium, isShadow: false, wordSpacing: 0, textColor: .label), for: .normal)
        }

        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.backgroundColor = .systemFill
        newGameButton.layer.cornerRadius = 10
        newGameButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        newGameButton.layer.borderWidth = 2
        newGameButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        newGameButton.addTarget(self, action: #selector(newGameButtonPressed(button:)), for: .touchUpInside)
        
        
        let scoreStackview = UIStackView()
        scoreStackview.translatesAutoresizingMaskIntoConstraints = false
        scoreStackview.axis = .vertical
        scoreStackview.alignment = .center
        scoreStackview.distribution = .fill
        scoreStackview.addArrangedSubview(gameStatus)
        
        if levelCompleted == true {
            levelCompletedLabel.attributedText = createAttributedText(text: "Level Completed", size: 30, fontWeight: .semibold, isShadow: false, wordSpacing: 0, textColor: .label)
            scoreStackview.addArrangedSubview(levelCompletedLabel)
        } else {
            levelCompletedLabel.attributedText = createAttributedText(text: "", size: 30, fontWeight: .semibold, isShadow: false, wordSpacing: 0, textColor: .label)
            scoreStackview.removeArrangedSubview(levelCompletedLabel)
        }
        
        scoreStackview.addArrangedSubview(scoreLabel)
        scoreStackview.addArrangedSubview(UIView())
        scoreStackview.addArrangedSubview(newGameButton)
        
        scoreCardView.addSubview(scoreStackview)

        NSLayoutConstraint.activate([
            scoreStackview.topAnchor.constraint(equalTo: scoreCardView.topAnchor, constant: 20),
            scoreStackview.trailingAnchor.constraint(equalTo: scoreCardView.trailingAnchor, constant: -20),
            scoreStackview.bottomAnchor.constraint(equalTo: scoreCardView.bottomAnchor, constant: -40),
            scoreStackview.leadingAnchor.constraint(equalTo: scoreCardView.leadingAnchor, constant: 20)
        ])
    }
    
    func slideUpScorecard() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.scorecardTopAnchor.constant = self.wordView.frame.height * 2 + self.batteryView.frame.height - 35
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func slideDownScorecard() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.scorecardTopAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func resetButtons() {
        //allLetters.removeAll()
        currentGuess.removeAll()
        //usedLetters.removeAll()
        correctWordCount = 0
        incorrectGuessCount = 0
 
        batteryView.resetBattery()
        lettersView.setupLetters()
    }
    
    func endGame(state: GameEndState) {
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
            
            gameStatus.attributedText = createAttributedText(text: "You Win!", size: 60, fontWeight: .bold, isShadow: false, wordSpacing: 0, textColor: .label)
        } else if state == .lose {
            score -= 5
            gameStatus.attributedText = createAttributedText(text: "You Lose!", size: 60, fontWeight: .bold, isShadow: false, wordSpacing: 0, textColor: .label)
        }
        
        setupScorecardView()
        slideUpScorecard()
    }
    
    
    @objc func newGameButtonPressed(button: UIButton) {
        //This does not work?
        if levelCompleted == true {
            print("Implement Next Level")
            resetButtons()
            nextWord()
            setupGame(newWord: currentWord)
            levelCompleted = false
            slideDownScorecard()
        } else {
            nextWord()
            slideDownScorecard()
            resetButtons()
            setupGame(newWord: currentWord)
        }
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
