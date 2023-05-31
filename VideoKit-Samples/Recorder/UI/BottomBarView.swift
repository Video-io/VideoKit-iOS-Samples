//
//  BottomBarView.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import Foundation
import SwiftUI
import AVKit
import Combine
import VideoKitRecorder

struct BottomBarView: View {
    
    let state: RecorderState
    let delete: (Bool) -> Void
    let resume: (Bool) -> Void
    let restart: () -> Void
    let send: () -> Void
    let toggle: () -> Void
    
    @State private var recordingRotationDegrees = 0.0
    
    private var showsToggle: Bool {
        if case .busy = state { return false }
        return true
    }
    
    private var showsSend: Bool {
        if case .busy = state { return false }
        return true
    }
    
    private var hasRecording: Bool {
        switch state {
        case .busy(let pending): return pending != nil
        case .idle(let pending): return pending != nil
        case .recording: return true
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            
            Image("Controls/Delete").onTapGesture {
                delete(hasRecording)
            }
            
            Image("Controls/Restart")
                .onTapGesture { restart() }
                .opacity(hasRecording ? 1.0 : 0.0)
                .allowsHitTesting(hasRecording)
            
            switch state {
            case .idle:
                Image("Controls/Record")
                    .onTapGesture { resume(true) }
            case .recording:
                ZStack {
                    Image("Controls/PauseIndicatorPng")
                        .rotationEffect(.degrees(recordingRotationDegrees))
                        .onAppear { withAnimation(.linear(duration: 0.8).speed(0.4).repeatForever(autoreverses: false)) { recordingRotationDegrees -= 360.0 } }
                    Image("Controls/Pause")
                }
                .onTapGesture { resume(false) }
            case .busy:
                Image("Controls/Record").opacity(0.0)
            }
            
            Image("Controls/Toggle")
                .onTapGesture { toggle() }
                .opacity(showsToggle ? 1.0 : 0.0)
                .allowsHitTesting(showsToggle)
            
            Image("Controls/Send")
                .onTapGesture { send() }
                .opacity(showsSend ? 1.0 : 0.5)
                .allowsHitTesting(showsSend)
        }
    }
}
