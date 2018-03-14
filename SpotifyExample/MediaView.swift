//
//  MediaView.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/11/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

protocol MediaDelegate{
    func mediaStarted()
    func mediaPaused()
    func mediaEnded()
}

class MediaView: UIView, MediaProtocol {

    public internal(set) var uid: String!
    public var delegate: MediaDelegate?
    var state: MediaState = .none
    
    deinit {
        if !shouldRemainPlaying{
            removeService()
        }
    }

    public required init(frame: CGRect, uid: String) {
        super.init(frame: frame)
        self.uid = uid
        self.state = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.state = .none
    }

    // precondition failure to force override else crash
    public func pause() {
        preconditionFailure("Pause method must be overridder")
    }
    
    
    public func play() {
        preconditionFailure("Play method must be overridder")
    }
    
    
    public func stop() {
        preconditionFailure("Stop method must be overridder")
    }
}
