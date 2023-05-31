//
//  TimerView.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import Foundation
import SwiftUI
import Combine
import VideoKitRecorder

private let colorOn = Color(red: 1.0, green: 19 / 255, blue: 0)
private let colorOff = Color(red: 14 / 255, green: 14 / 255, blue: 14 / 255)

struct TimerView: View {
    
    let time: AnyPublisher<String, Never>
    let state: RecorderState
    @State var currentTime: String = "00:00"
    
    private var recording: Bool {
        if case .recording = state {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if !recording {
                Image("Controls/Timer")
            }
            Text(currentTime)
            .font(.system(size: 12.0, weight: .regular, design: .default))
            .foregroundColor(Color.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill(recording ? colorOn : colorOff))
        .onReceive(time) { currentTime = $0 }
    }
}
