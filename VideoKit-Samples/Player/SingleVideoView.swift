//
//  SingleVideoView.swift
//  VideoKit-Samples
//
//  Created by Mattia on 26/05/23.
//

import Foundation
import SwiftUI
import VideoKitPlayer

struct SingleVideoView : View {
    let viewModel: SingleVideoViewModel
    let exit: () -> Void
    
    var body: some View {
        ZStack {
            PlayerViewRepresentable(viewModel: viewModel)
                .onTapGesture { viewModel.player.toggle() }
            
            Button("Back") { exit() }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 16)
        }
    }
}


private struct PlayerViewRepresentable : UIViewControllerRepresentable {
    let viewModel: SingleVideoViewModel
    
    func makeUIViewController(context: Context) -> PlayerViewController {
        return viewModel.player
    }
    
    func updateUIViewController(_ uiViewController: PlayerViewController, context: Context) {
        // Nothing to do
    }
}
