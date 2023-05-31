//
//  Sample.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import Foundation
import VideoKitCore

enum Sample {
    case recorder(payload: RecorderViewModel)
    case playVideo(payload: SingleVideoViewModel)
    case playFeed(payload: FeedViewModel)
}
