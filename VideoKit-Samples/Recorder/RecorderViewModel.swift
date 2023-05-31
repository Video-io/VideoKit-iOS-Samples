//
//  RecorderViewModel.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import Foundation
import Combine
import VideoKitCore
import VideoKitRecorder

class RecorderViewModel : ObservableObject {

    let recorder: RecorderViewController

    lazy var formattedDuration = {
        recorder
            .durationPublisher(throttle: 0.2)
            .map { seconds in
                let m = Int(seconds.truncatingRemainder(dividingBy: 3600) / 60)
                let s = Int(seconds.truncatingRemainder(dividingBy: 60))
                return String(format: "%i:%02i", m, s)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    init(
        videoOptions: VideoOptions = .init(),
        audioOptions: AudioOptions = .init(),
        uploadParams: UploadParams? = .init(),
        cameraDirection: CameraDirection = .back
    ) {
        self.recorder = .init(videoOptions: videoOptions, audioOptions: audioOptions, uploadParams: uploadParams, cameraDirection: cameraDirection)
        
        if RecorderAuthorizations.video() != .granted {
            RecorderAuthorizations.requestVideo()
        }
        if RecorderAuthorizations.audio() != .granted, recorder.audioOptions.source != .none {
            RecorderAuthorizations.requestAudio()
        }
    }
}
