//
//  VideoKit_SamplesApp.swift
//  VideoKit-Samples
//
//  Created by Mattia on 25/05/23.
//

import SwiftUI
import VideoKitCore

let VideoKitAppToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2lkIjoiMW81cFBiVzMwNG44SXVwR2JVSm8iLCJyb2xlIjoiYXBwIiwiaWF0IjoxNjEyMTY2MzkwLCJpc3MiOiJ2aWRlby5pbyIsImp0aSI6ImZQN290S3dFb2V5U2tGNVNzQVBmLXdkaDU1In0.ebYY3nXYCyc9b8NuQZ742ejLEKsqxh0lZiK7FjtmKBM"

let VideoKitUserId = UUID().uuidString

class SamplesAppViewModel : ObservableObject {
    init() {
        precondition(!VideoKitAppToken.isEmpty, "Please set the VideoKitAppToken variable.")
        VideoKit.sessions().start(
            appToken: VideoKitAppToken,
            identity: VideoKitUserId
        )
        Logger.enableLogging()
    }
    
    @Published var sample: Sample? = nil
    @Published var message: String? = nil
    
    func close() {
        sample = nil
    }
    
    func openRecorder() {
        message = nil
        sample = .recorder(payload: RecorderViewModel())
    }
    
    func openVideoPlayer() {
        message = "Loading latest video..."
        let req = FilteredVideosRequest(limit: 1)
        VideoKit.videos().list(req) { [weak self] array, err in
            DispatchQueue.main.async {
                if let video = array.first {
                    self?.message = nil
                    self?.sample = .playVideo(payload: SingleVideoViewModel(video: video))
                } else {
                    self?.message = "Could not find any playable video for the given VideoKit app token. Err: \(err?.localizedDescription ?? "nil")"
                }
            }
        }
    }
    
    func openVideoPlaylist() {
        message = "Loading playlist with latest videos..."
        let spec = FilteredPlaylistSpec()
        VideoKit.videos().loadPlaylist(spec) { [weak self] playlist, err in
            DispatchQueue.main.async {
                if let playlist, playlist.count > 0 {
                    self?.message = nil
                    self?.sample = .playFeed(payload: FeedViewModel(playlist: playlist))
                } else {
                    self?.message = "Could not find any playable video for the given VideoKit app token. Err: \(err?.localizedDescription ?? "nil")"
                }
            }
        }
    }
}

@main
struct SamplesApp: App {
    @StateObject var viewModel = SamplesAppViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.sample {
            case nil:
                ZStack {
                    if let message = viewModel.message {
                        Text(message)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.all, 16)
                    }
                    VStack(spacing: 16) {
                        Button("Recorder") { viewModel.openRecorder() }
                        Button("Player (Single video)") { viewModel.openVideoPlayer() }
                        Button("Player (TikTok-like feed)") { viewModel.openVideoPlaylist() }
                    }
                }
                
            case .recorder(let vm):
                RecorderView(viewModel: vm, exit: viewModel.close)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .playVideo(let vm):
                SingleVideoView(viewModel: vm, exit: viewModel.close)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .playFeed(let vm):
                FeedView(viewModel: vm, exit: viewModel.close)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
