//
//  FeedView.swift
//  VideoKit-Samples
//
//  Created by Mattia on 26/05/23.
//

import Foundation


import Foundation
import SwiftUI
import VideoKitPlayer

struct FeedView : View {
    let viewModel: FeedViewModel
    let exit: () -> Void
    
    var body: some View {
        ZStack {
            PagerViewRepresentable(viewModel: viewModel)
            
            Button("Back") { exit() }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 16)
        }
    }
}

private struct PagerViewRepresentable : UIViewControllerRepresentable {
    let viewModel: FeedViewModel
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        return viewModel.pager
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        // Nothing to do
    }
}

