//
//  RecorderView.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import Foundation
import SwiftUI
import VideoKitRecorder

struct RecorderView : View {
    let viewModel: RecorderViewModel
    let exit: () -> Void
    
    var body: some View {
        ZStack {
            RecorderViewRepresentable(viewModel: viewModel)
            
            RecorderControls(recorder: viewModel.recorder, duration: viewModel.formattedDuration, exit: exit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


private struct RecorderViewRepresentable : UIViewControllerRepresentable {
    let viewModel: RecorderViewModel
    
    func makeUIViewController(context: Context) -> RecorderViewController {
        return viewModel.recorder
    }
    
    func updateUIViewController(_ uiViewController: RecorderViewController, context: Context) {
        // Nothing to do
    }
}
