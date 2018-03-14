//
//  MediaProtocol.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/11/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

enum MediaType {
    case audio
    case video
}

enum MediaState{
    case playing
    case paused
    case stopped
    case ended
    case error
    case none
}
protocol MediaProtocol: class {
    func play()    
    func pause()
    func stop()
    func removeService()
    var shouldAddControls: Bool { get }
    var shouldRemainPlaying: Bool { get }
    var state: MediaState { get set }
    init(frame: CGRect, uid: String)
}

extension MediaProtocol{
    func removeService() {}
    var shouldAddControls: Bool { return false }
    var shouldRemainPlaying: Bool { return false }
    var mediaType: MediaType { return .audio }
}
