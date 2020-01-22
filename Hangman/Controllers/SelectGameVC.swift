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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func initialUserDefault() {
        defaults.set(1, forKey: "Level")
        defaults.set(false, forKey: "CompletedAllLevels")
    }


}
