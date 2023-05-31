//
//  RecorderControls.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import Foundation
import VideoKitRecorder
import SwiftUI
import Combine

struct RecorderControls<R: RecorderProtocol>: View {
    
    @ObservedObject var recorder: R
    let duration: AnyPublisher<String, Never>
    let exit: () -> Void

    private var shouldShowBottomBar: Bool {
        if case .busy = recorder.state { return false }
        return true
    }
    
    private var shouldShowTimer: Bool {
        let pending = recorder.recording
        return pending != nil
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            if shouldShowTimer {
                TimerView(time: duration, state: recorder.state)
            }
            
            Spacer()
            
            if shouldShowBottomBar {
                BottomBarView(
                    state: recorder.state,
                    delete: { hasRecording in
                        if hasRecording { recorder.reset { } }
                        else { exit() }
                    },
                    resume: { start in
                        if start { recorder.start { _, _ in } }
                        else { recorder.pause { _, _ in } }
                    },
                    restart: {
                        Task {
                            await recorder.reset()
                            try await recorder.start()
                        }
                    },
                    send: {
                        recorder.stop(finalizeUpload: true) { _, _ in }
                    },
                    toggle: {
                        recorder.camera.toggleDirection()
                    }
                )
            }
        }
        .padding(.all, 16)
    }
}
