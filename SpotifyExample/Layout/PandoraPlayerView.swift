//
//  PandoraPlayer.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class PandoraPlayerView: UIView {
    let colors = Colors()
    var playerContainer : UIView!
    var playbackSlider : UISlider!
    var seekForward : UIButton!
    var seekBackward : UIButton!
    var playButton : UIButton!
    var playButtonImage : UIImage!
    var pauseButton : UIButton!
    var pauseButtonImage : UIImage!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        setupContainer()
        addSeekBackwardButtonToContainer()
        addPlaybackSliderToContainer()
        setBackgroundColor()
    }
    
    private func setBackgroundColor() {
        self.backgroundColor = colors.footerBackground
    }
    
    private func setupContainer() {
        playerContainer = UIView()
        addPlayerContainer()
        addSeekBackwardButtonToContainer()
        addPlaybackSliderToContainer()
        addSeekForwardButtonToContainer()
    }
    
    private func addPlayerContainer() {
        self.addSubview(playerContainer)
        addPlayerContainerConstraints()
    }
    
    private func addPlayerContainerConstraints() {
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        let playerContainerWidth = self.frame.width * 0.9
        let playerContainerHeight = self.frame.height
        playerContainer.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        playerContainer.heightAnchor.constraint(equalToConstant: playerContainerHeight).isActive = true
        playerContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playerContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playerContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
    }
    
    private func addSeekBackwardButtonToContainer() {
        seekBackward = UIButton()
        seekBackward.tag = 0
        seekBackward.translatesAutoresizingMaskIntoConstraints = false
        seekBackward.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        seekBackward.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        seekBackward.setTitle("<", for: .normal)
        seekBackward.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        seekBackward.setTitleColor(UIColor(red: CGFloat(155.0/255.0), green: CGFloat(155.0/255.0), blue: CGFloat(155.0/255.0), alpha: 1.0), for: .normal)
        seekBackward.titleLabel?.textAlignment = .center
        playerContainer.addSubview(seekBackward)
        addSeekBackwardConstraints()
    }
    
    private func addSeekBackwardConstraints() {
        seekBackward.translatesAutoresizingMaskIntoConstraints = false
        seekBackward.leftAnchor.constraint(equalTo: playerContainer.leftAnchor, constant: 0.0).isActive = true
        seekBackward.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor, constant: 0.0).isActive = true
    }
    
    private func addPlaybackSliderToContainer() {
        playbackSlider = UISlider()
        playerContainer.addSubview(playbackSlider)
        addPlaybackSliderConstraints()
    }
    
    private func addPlaybackSliderConstraints() {
        playbackSlider.translatesAutoresizingMaskIntoConstraints = false
        playbackSlider.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        playbackSlider.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        playbackSlider.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor).isActive = true
        playbackSlider.leftAnchor.constraint(equalTo: seekBackward.rightAnchor, constant: 0.0).isActive = true
    }
    
    private func addPlayButton() {
        let playLabel = UILabel()
        playLabel.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        playLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    
    private func addSeekForwardButtonToContainer() {
        seekForward = UIButton()
        seekForward.tag = 0
        seekForward.translatesAutoresizingMaskIntoConstraints = false
        seekForward.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        seekForward.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        seekForward.setTitle(">", for: .normal)
        seekForward.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        seekForward.setTitleColor(UIColor(red: CGFloat(155.0/255.0), green: CGFloat(155.0/255.0), blue: CGFloat(155.0/255.0), alpha: 1.0), for: .normal)
        seekForward.titleLabel?.textAlignment = .center
        playerContainer.addSubview(seekForward)
        addSeekForwardConstraints()
    }
    
    private func addSeekForwardConstraints() {
        seekForward.translatesAutoresizingMaskIntoConstraints = false
        seekForward.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor, constant: 0.0).isActive = true
        seekForward.leftAnchor.constraint(equalTo: playbackSlider.rightAnchor, constant: 0.0).isActive = true
    }
}
