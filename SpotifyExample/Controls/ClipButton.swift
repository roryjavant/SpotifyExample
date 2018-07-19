//
//  ClipButton.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/27/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class ClipButton: UIButton {
    
    let clipPlayer = ClipPlayer.sharedPlayer
    static var clipButtons = [UIButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()        
    }

    private func setup() {
        setProperties()
        setInitialLayer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCellPropertiesForChainsActivation), name: NSNotification.Name(rawValue: "chainActivated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCellPropertiesForChainsDeactivation), name: NSNotification.Name(rawValue: "chainDeactivated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetButtons(button:)), name: NSNotification.Name(rawValue: "audioDidFinishPlaying"), object: nil)
    }
    
    private func setProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEnabled = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.isHidden = false
        self.isSelected = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        self.setTitle("One More Rep!", for: .normal)
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(clipButtonPressed(button:)), for: .touchUpInside)
    }
    
    @objc func  clipButtonPressed(button: UIButton) {
        if !chainIsActivated() {
            resetButtons(button: button)
            setLayerForButtonState(button: button)
            startAudio(button: button)
        }
        else {
            setLayerForSelected(button: button)
        }
    }
    
    private func startAudio(button: UIButton) {
        clipPlayer.button_click(button: button)
    }
    
    @objc private func setCellPropertiesForChainsActivation() {
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 1.5
        resetButtons(button: UIButton())
        clipPlayer.stop()
    }
    
    @objc private func setCellPropertiesForChainsDeactivation() {        
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1.0
        resetToInitialLayer()
        clipPlayer.stop()
    }
    
    private func setInitialLayer() {
        let selectedLayer = SelectedLayer(button: self)
        self.layer.insertSublayer(selectedLayer, at: 0)
    }
    
    private func resetToInitialLayer() {
        for button in ClipButton.clipButtons {
             let layer = SelectedLayer(button: button)
            button.layer.sublayers![0].removeFromSuperlayer()
            button.layer.insertSublayer(layer, at: 0)
        }
    }
    
    private func setLayerForButtonState(button: UIButton) {
        if self.isSelected {
            self.isSelected = false
            setLayerForUnselected(button: button)
        }
        else {
            self.isSelected = true
            setLayerForSelected(button: button)
        }
    }
    
    private func setLayerForSelected(button: UIButton) {
        let layer = SelectedLayer(button: button)
        self.layer.replaceSublayer(button.layer.sublayers![0], with: layer)
        setSelectedTitleFont(button: button)
    }
    
    private func setLayerForUnselected(button: UIButton) {
        let layer = UnselectedLayer(button: button)
        button.layer.sublayers![0].removeFromSuperlayer()
        button.layer.insertSublayer(layer, at: 0)
        setUnselectedTitleFont(button: button)
    }
    
   @objc private func resetButtons(button: UIButton) {
        for clipButton in ClipButton.clipButtons {
            if clipButton != button {            
                    clipButton.isSelected = false
                    setLayerForUnselected(button: clipButton)
            }
        }
    }
    
    private func setSelectedTitleFont(button: UIButton) {
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    }
    
    private func setUnselectedTitleFont(button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
    }
    
    private func chainIsActivated() -> Bool {
        return ChainsModel.sharedModel.isChainsActivated
    }
}
