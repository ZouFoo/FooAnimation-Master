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
        renderer.canvasMargin = UIEdgeInsets(top: 0, left: 0, bottom: SCREEN_HEIGHT -  SCREEN_WIDTH/1.78 - 44 - 64, right: 10)
        
        initDanmuText()
        return renderer
    }()
    
    func initDanmuText() {
        danmuText += ["滴滴：一直严禁员工私下交易期权","从未有过明确的上市时间表","滴滴对投资人开始转让原始股的消息做出回应。","9月27日，有报道称","从2018年年初到现在，滴滴D轮以后投资人开始转让滴滴的原始股","而接盘方系滴滴的投资方软银中国资本。","该报道还称， 滴滴核心团队及部分早期员工","正在按照接近26美元／股转让期权，价格略高于原有价格。"]
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (SCREEN_WIDTH - 30)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: Int(SCREEN_WIDTH/1.78), width: Int(SCREEN_WIDTH), height: Int(SCREEN_HEIGHT) - Int(SCREEN_WIDTH/1.78) - 64 - 44), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier:"HomeCollectionViewCell")

        
        collectionView.backgroundColor = .black
        initdatas()
        return collectionView
        
    }()
    
    func initdatas() {
        animations += ["日历calendar","Emitter粒子动画","IQKeyboardManager","ScrollLayout","Eureka表单","s6"]
        animationImages += ["s1","s2","s3","s4","s5","s6"]
    }
    
    
    //MARK: - Life
    override func loadView() {
        super.loadView()
        if self.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = []
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "Foo_Animations"
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

        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(CalendarViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(EmitterViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(IQKeyboardManagerViewController(), animated: true)
        case 3:
            let vc = ScrollViewController.shared
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            self.navigationController?.pushViewController(EurekaViewController(), animated: true)
        default: break
            
        }
    }
    
}

