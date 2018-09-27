//
//  ViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/9/27.
//  Copyright © 2018年 ZouFoo. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    lazy var player: AVPlayer = {
        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "208.MP4", ofType: nil)
        let videoURL = URL(fileURLWithPath: filePath!)
        //定义一个playerItem，并监听相关的通知
        let playerItem = AVPlayerItem(url: videoURL)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(playerItem: playerItem)
        
        return player
    }()
    
    lazy var avPlayer: AVPlayerLayer = {
        
        //设置大小和位置（全屏）
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH/1.78)
        return playerLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.addSublayer(avPlayer)
        //开始播放
        player.play()
    }

    
    //视频播放完毕响应
    @objc func playerDidFinishPlaying() {
        player.seek(to: CMTimeMake(value: 0, timescale: 1))
        player.play()
    }

}

