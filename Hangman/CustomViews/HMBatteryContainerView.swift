//
//  HMBatteryContainerView.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/10/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class HMBatteryContainerView: UIView {

    let batteryImageview: UIImageView = {
        let imageview = UIImageView(image: UIImage.init(named: "Battery.pdf"))
        return imageview
    }()
    
    let batteryFillView = HMBatteryFillView()
    
    var batteryFillViewTrailingAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getBatterySize() -> CGSize {
        return CGSize.init(width: batteryImageview.frame.width, height: batteryImageview.frame.height)
    }
    
    func reduceBattery(multiple: Int) {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {
            if multiple <= 3 {
                self.batteryFillView.backgroundColor = .systemGreen
            } else if multiple > 3 && multiple <= 5 {
                self.batteryFillView.backgroundColor = .systemYellow
            } else if multiple > 5 {
                self.batteryFillView.backgroundColor = .systemRed
            }
            
            self.batteryFillViewTrailingAnchor.constant = -(CGFloat(multiple) * (self.frame.width / 7))
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func resetBattery() {
        //Reset Battery fill
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.batteryFillViewTrailingAnchor.constant = -20
            self.batteryFillView.backgroundColor = .systemGreen
            self.layoutIfNeeded()
        }, completion: nil )
    }
    
    private func configure() {
        self.addSubview(batteryImageview)
        self.addSubview(batteryFillView)
        self.sendSubviewToBack(batteryFillView)
        translatesAutoresizingMaskIntoConstraints = false
    
        batteryFillViewTrailingAnchor = batteryFillView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            batteryFillView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            batteryFillView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            batteryFillView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            batteryFillViewTrailingAnchor,
        ])
    }
    
}
