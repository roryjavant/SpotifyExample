//
//  LoginButton.swift
//  SpotifyExample
//
//  Created by Rory Avant on 6/29/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    let api = API.sharedAPI
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.setTitle("Login", for: .normal)
        self.addTarget(self, action: #selector(self.loginButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        self.setTitleColor(.black, for: .normal)
    }
    
    @objc private func loginButtonPressed(sender: UIButton) {
        UIApplication.shared.open(api.loginUrl!, options: [:], completionHandler: {
            (success) in
            print("Open")
        })
    }
    
}
