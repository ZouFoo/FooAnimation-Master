//
//  ViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/9/27.
//  Copyright © 2018年 ZouFoo. All rights reserved.
//

import UIKit
import AVKit
import BarrageRenderer

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    var isPlay: Bool = true
    var rendererTimer: Timer?
    var timerIsInvalidate: Bool = false
    var animations = [String]()
    var animationImages = [String]()

    //MARK: - Attributes
    var danmuText = [String]()
    
    
    //MARK: - UI
    lazy var player: AVPlayer = {
        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "208", ofType: "MP4")
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
    
    lazy var playButton: UIButton = {
        let playButton = UIButton(frame: CGRect(x: 10, y: SCREEN_WIDTH/1.78 - 50, width: 40, height: 40))
        playButton.setImage(UIImage(named: "stop"), for: .normal)
        playButton.addTarget(self, action: #selector(tapPlayButotn), for: .touchUpInside)
        return playButton
    }()
    
    lazy var renderer: BarrageRenderer = {
        let renderer = BarrageRenderer.init()
        renderer.canvasMargin = UIEdgeInsets(top: 44, left: 0, bottom: SCREEN_HEIGHT -  SCREEN_WIDTH/1.78 + 44, right: 10)
        
        initDanmuText()
        return renderer
    }()
    
    func initDanmuText() {
        danmuText += ["滴滴：一直严禁员工私下交易期权，从未有过明确的上市时间表","滴滴对投资人开始转让原始股的消息做出回应。","9月27日，有报道称，从2018年年初到现在，滴滴D轮以后投资人开始转让滴滴的原始股，而接盘方系滴滴的投资方软银中国资本。","该报道还称， 滴滴核心团队及部分早期员工，正在按照接近26美元／股转让期权，价格略高于原有价格。","自从加盟火箭之后，戈登一直打第六人，而且成为过最佳第六人。","上赛季，火箭尝试让戈登和哈登、保罗一起搭档并组成三后卫阵容，而且取得不错的效果。","数据显示：上赛季常规赛，戈登、哈登和保罗一起搭档了150分钟，进攻效率是惊人的每100回合得到134.7分，防守效率也还可以（每100回合丢105.8分）。","据著名NBA记者蒂姆-迈克马洪报道，火箭队倾向于在下赛季让最佳第六人埃里克-戈登进入首发阵容并和哈登、保罗搭档。","今年夏天，安东尼加盟火箭，而且他在媒体日上承认自己不介意打替补。","如果是这样的话，火箭的板凳得分能由安东尼来填补。"]
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (SCREEN_WIDTH - 30)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: Int(SCREEN_WIDTH/1.78), width: Int(SCREEN_WIDTH), height: Int(SCREEN_HEIGHT) - Int(SCREEN_WIDTH/1.78)), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier:"HomeCollectionViewCell")

        
        collectionView.backgroundColor = .black
        initdatas()
        return collectionView
        
    }()
    
    func initdatas() {
        animations += ["s1","s2","s3","s4","s5","s6"]
        animationImages += ["s1","s2","s3","s4","s5","s6"]
    }
    
    
    //MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.addSublayer(avPlayer)
        //开始播放
        player.play()
        self.view.addSubview(playButton)
        addRenderer()
        self.view.addSubview(collectionView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 离开页面 销毁计时器  视频暂停
        rendererTimer?.invalidate()
        timerIsInvalidate = true
        player.pause()
        isPlay = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
    }
    
    func addRenderer() {
        self.view.addSubview(renderer.view)
        let safeObj = NSSafeObject.init(object: self, with: #selector(autoSenderBarrage))
        rendererTimer = Timer.scheduledTimer(timeInterval: 2, target: safeObj!, selector: #selector(NSSafeObject.excute), userInfo: nil, repeats: true)
        renderer.start()
    }
    
    @objc func autoSenderBarrage() {
        let spriteNumber :NSInteger = renderer.spritesNumber(withName: nil)
        if spriteNumber <= 10 {
            renderer.receive(walkTextSpriteDescriptorWithDirection(direction: BarrageWalkDirection.R2L.rawValue))
        }
        

    }
    
    func walkTextSpriteDescriptorWithDirection(direction:UInt) -> BarrageDescriptor{
        let descriptor:BarrageDescriptor = BarrageDescriptor()
        descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self)
        descriptor.params["text"] = self.danmuText[Int(arc4random())%(self.danmuText.count)]
        descriptor.params["textColor"] = UIColor(red: CGFloat(arc4random()%255) / 255, green: CGFloat(arc4random()%255) / 255, blue: CGFloat(arc4random()%255) / 255, alpha: 1)
        descriptor.params["speed"] = Int(arc4random()%100) + 50
        descriptor.params["direction"] = direction
        return descriptor
    }
 
    

    
    @objc func tapPlayButotn() {
        if isPlay == true{
            player.pause()
            isPlay = false
            playButton.setImage(UIImage(named: "play"), for: .normal)
            if timerIsInvalidate == false {
                rendererTimer!.fireDate = Date.distantFuture
            }
            
        }else {
            player.play()
            isPlay = true
            playButton.setImage(UIImage(named: "stop"), for: .normal)
            if timerIsInvalidate == false {
                rendererTimer!.fireDate = Date.distantPast
            }
            


        }
        
    }
    
    //视频播放完毕响应
    @objc func playerDidFinishPlaying() {
        player.seek(to: CMTimeMake(value: 0, timescale: 1))
        player.play()
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animations.count
    }
    
    //分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
//        cell.config(title: animations[indexPath.row], imageName: animationImages[Int(arc4random() % 10)]) // 随机数  0 - 9
        cell.config(title: animations[indexPath.row], imageName: animationImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.present(EmitterViewController(), animated: true, completion: nil)
        self.present(CalendarViewController(), animated: true, completion: nil)
    }
    
}

