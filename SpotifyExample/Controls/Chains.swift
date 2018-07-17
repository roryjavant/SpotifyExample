//
//  Chains.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/24/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class Chains: UIStackView {
    
    let colors = Colors()
    var chains : [UIButton]!
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setChainsProperties()
        createChainsButtons()
        addChainsButtons()
        addChainsConstraints()
        addButtonTargets()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        setChainsProperties()
        createChainsButtons()
        addChainsButtons()
        addChainsConstraints()
        addButtonTargets()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setChainsProperties() {
        self.backgroundColor = Colors().chainsBackground
        self.axis = .horizontal
        self.spacing = 2
        self.distribution = .fillEqually
        self.alignment = .center
    }
    
    private func createChainsButtons() {
        chains = createButtons(named: "1", "2", "3", "4")
    }
    
    private func createButtons(named: String...) -> [UIButton] {
        return named.map { text in
            let button = UIButton()
            button.tag = Int(text)!
            setButtonProperties(button: button, text: text)
            setButtonLayerProperties(button: button)
            return button
        }
    }
    
    private func setButtonProperties(button: UIButton, text: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        setButtonLayerProperties(button: button)
    }
    
    private func setButtonLayerProperties(button: UIButton) {
        button.layer.cornerRadius = 3.0
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset  = CGSize(width: 3.0, height: 3.0)
        button.isSelected = false
        button.isUserInteractionEnabled = true
    }
    
    private func addChainsButtons() {
        for chainButton in chains {
            self.addArrangedSubview(chainButton)
            chainButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        }
    }
    
    private func addChainsConstraints() {
        
    }
    
    private func addButtonTargets() {
        for chainButton in chains {
            switch chainButton.tag {
                case 1 : chainButton.addTarget(self, action: #selector(chainButtonOnePush(button:))   ,   for: .touchUpInside)
                case 2 : chainButton.addTarget(self, action: #selector(chainButtonTwoPush(button:))   ,   for: .touchUpInside)
                case 3 : chainButton.addTarget(self, action: #selector(chainButtonThreePush(button:)) ,   for: .touchUpInside)
                case 4 : chainButton.addTarget(self, action: #selector(chainButtonFourPush(button:))  ,   for: .touchUpInside)
                default: print("Chains.addButtonTargets() Switch Default Case Hit.")
            }
        }
    }
    
    @objc private func chainButtonOnePush(button: UIButton) {
        setChainButtonColor(forButton: button)
    }
    
    @objc private func chainButtonTwoPush(button: UIButton) {
        setChainButtonColor(forButton: button)
    }
    
    @objc private func chainButtonThreePush(button: UIButton) {
        setChainButtonColor(forButton: button)
    }
    
    @objc private func chainButtonFourPush(button: UIButton) {
        setChainButtonColor(forButton: button)
    }
    
    private func setChainButtonColor(forButton button: UIButton) {
        button.isSelected ? setPropertiesForUnselectedButtonState(button: button) : setPropertiesForSelectedButtonState(button: button)
    }
    
    private func setPropertiesForSelectedButtonState(button: UIButton) {
        switch button.tag {
        case 1 : button.backgroundColor = .green
        case 2 : button.backgroundColor = .blue
        case 3 : button.backgroundColor = .red
        case 4 : button.backgroundColor = .yellow
        default: print("Chains.setPropertiesForSelectedButtonState Switch Default Case Hit.")
        }
        button.isSelected = true
        turnOffUnselectedButton(buttonToKeepOn: button)
        notifyGridCellOfChainActivation()
    }
    
    private func setPropertiesForUnselectedButtonState(button: UIButton) {
        button.backgroundColor = colors.chainsBackground
        button.isSelected = false
        checkChainsActivationStatus()
    }
    
    private func turnOffUnselectedButton(buttonToKeepOn button: UIButton) {
        for chainButton in chains {
            if chainButton != button {
                chainButton.isSelected = false
                chainButton.backgroundColor = colors.chainsBackground
            }
        }
    }
    
    private func checkChainsActivationStatus() {
        if checkIfAllChainsDeactivated() {
            notifyGridCellOfChainDeactivation()
        } else {
            notifyGridCellOfChainActivation()
        }
    }
    
    private func notifyGridCellOfChainActivation() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chainActivated"), object: nil)
    }
    
    private func notifyGridCellOfChainDeactivation() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chainDeactivated"), object: nil)
    }
    
    private func checkIfAllChainsDeactivated() -> Bool {
        for chainButton in chains {
            if chainButton.isSelected == true {
                return false
            }
        }
        return true
    }
}
