//
//  SelectGameVC.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/21/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class SelectGameVC: UIViewController {

    let defaults = UserDefaults.standard
    let logoImage = HMBatteryContainerView()
    let wordBackgroundView = HMCustomBackgroundView()
    let localNewGameButton = HMSelectGameButton.init(title: "New Game")
    let networkNewGameButton = HMSelectGameButton.init(title: "Discover New Words")
    
    let padding: CGFloat = 40
    let textHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUserDefault()
        configureViewController()
        configureLogoImage()
        configureNetworkNewGameButton()
        configureLocalNewGameButton()
        configureCustomBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Wo?d D?ain"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wordBackgroundView.animateWords()
        #warning("Problem with loading when dismissed from MainVC")
    }
    
    func initialUserDefault() {
        defaults.set(1, forKey: "Level")
        defaults.set(false, forKey: "CompletedAllLevels")
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backItem?.title = "Exit"
    }
    
    func configureLogoImage() {
        view.addSubview(logoImage)
        let batterySize = logoImage.getBatterySize()
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: batterySize.width),
            logoImage.heightAnchor.constraint(equalToConstant: batterySize.height)
        ])
    }
    
    func configureLocalNewGameButton() {
        view.addSubview(localNewGameButton)
        localNewGameButton.addTarget(self, action: #selector(localNewGameButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            localNewGameButton.bottomAnchor.constraint(equalTo: networkNewGameButton.topAnchor, constant: -20),
            localNewGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            localNewGameButton.heightAnchor.constraint(equalToConstant: textHeight),
            localNewGameButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
    }
    
    func configureNetworkNewGameButton() {
        view.addSubview(networkNewGameButton)
        networkNewGameButton.addTarget(self, action: #selector(networkNewGameButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            networkNewGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            networkNewGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            networkNewGameButton.heightAnchor.constraint(equalToConstant: textHeight),
            networkNewGameButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
    }
    
    func configureCustomBackground() {
        view.addSubview(wordBackgroundView)

        NSLayoutConstraint.activate([
            wordBackgroundView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 0),
            wordBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            wordBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            wordBackgroundView.bottomAnchor.constraint(equalTo: localNewGameButton.topAnchor, constant: 0)
        ])
    }
    
    @objc func localNewGameButtonPressed() {
        let newGameVC = MainVC()
        let currentLevel = defaults.integer(forKey: "Level")
        newGameVC.level = currentLevel
        newGameVC.navBarLabel.text = "Level \(currentLevel)"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(newGameVC, animated: true)
    }
    
    @objc func networkNewGameButtonPressed() {
        print("Network Game Button Pressed")
     
        #warning("Testing Network")
        //getWordOfTheDay()
        getListOfRandomWords()
    }

    func getListOfRandomWords() {
        NetworkManager.shared.getListOfWords { [weak self](result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let words):
                print("List of Words(Array): \(words)")
            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Problem Occurred", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func getWordOfTheDay() {
        NetworkManager.shared.getWordOfTheDay { [weak self](result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let word):
                print("Word of the day is: \(word)")
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}
