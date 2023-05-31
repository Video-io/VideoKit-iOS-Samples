//
//  SingleVideoViewModel.swift
//  VideoKit-Samples
//
//  Created by Mattia on 26/05/23.
//

import Foundation
import Combine
import VideoKitCore
import VideoKitPlayer

class SingleVideoViewModel : ObservableObject {

    let player: PlayerViewController

    init(video: Video) {
        self.player = PlayerViewController()
        self.player.loop = true
        self.player.set(video: video, play: true)
    }
}
