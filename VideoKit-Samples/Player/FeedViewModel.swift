//
//  FeedViewModel.swift
//  VideoKit-Samples
//
//  Created by Mattia on 26/05/23.
//

import Foundation
import Combine
import VideoKitCore
import VideoKitPlayer
import UIKit

class FeedViewModel : NSObject, ObservableObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let players: PlayersManager
    let pager: UIPageViewController

    init(playlist: any Playlist) {
        self.players = PlayersManager(playlist: playlist)
        self.pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        super.init()
        self.pager.dataSource = self
        self.pager.delegate = self
        
        if let first = try? Item(players: players, index: 0) {
            self.pager.setViewControllers([first], direction: .forward, animated: false)
            first.makeCurrent()
        }
    }
    
    // NOTE: does NOT react to changes in the playlist. To do so, one has to subscribe to playlist changes
    class Item : UIViewController {
        
        let players: PlayersManager
        let player: Player
        let index: Int
        
        init(players: PlayersManager, index: Int) throws {
            self.players = players
            self.player = try players.get(at: index)
            self.index = index
            super.init(nibName: nil, bundle: nil)
            self.player.loop = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func viewDidLoad() {
            view.addSubview(player.view)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        
        open override func viewDidLayoutSubviews() {
            player.view.frame = view.bounds
        }
        
        @objc func viewTapped() {
            player.toggle()
        }
        
        func makeCurrent() {
            players.currentIndex = index
            player.play()
        }
        
        deinit {
            players.release(player)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let video = (viewController as! Item).player.video,
            let index = players.playlist.videos.firstIndex(of: video)
        else {
            return nil
        }
        return try? Item(players: players, index: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let video = (viewController as! Item).player.video,
            let index = players.playlist.videos.firstIndex(of: video)
        else {
            return nil
        }
        return try? Item(players: players, index: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let item = pageViewController.viewControllers![0] as! Item
            item.makeCurrent()
        }
    }
}
