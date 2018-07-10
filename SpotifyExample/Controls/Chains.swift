//
//  Chains.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/24/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class Chains: UIStackView {

    static let sharedChains = Chains()
    var chains : [UIButton]!
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        setChainsProperties()
        createChainsButtons()
        addChainsButtons()
        addChainsConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setChainsProperties() {
        self.backgroundColor = Colors().chainsBackground
        self.translatesAutoresizingMaskIntoConstraints = false
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
            setButtonProperties(button: button, text: text)
            setButtonLayerProperties(button: button)
            return button
        }
    }
    
    private func setButtonProperties(button: UIButton, text: String) {
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
        button.isUserInteractionEnabled = true
    }
    
    private func addChainsButtons() {
        for chainButton in chains {
            self.addArrangedSubview(chainButton)
        }
    }
    
    private func addChainsConstraints() {
        self.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.widthAnchor.constraint(equalToConstant: 250.0).isActive = true

    }
    
}
