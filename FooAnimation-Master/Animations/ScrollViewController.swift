//
//  ScrollViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/24.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
//class ScrollViewController: BaseViewController {
//Instance
    static let shared = ScrollViewController()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (SCREEN_WIDTH - 30)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
//        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH), height: Int(SCREEN_HEIGHT)), collectionViewLayout: layout)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier:"HomeCollectionViewCell")
        
        
        collectionView.backgroundColor = .black
        return collectionView
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue:"isTest"), object: nil)

    }
    
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
//    实现通知监听方法
    @objc func test(nofi : Notification){
        let str = nofi.userInfo!["post"]
        print(String(describing: str!) + "this notifi")
    }
    

}


extension ScrollViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    //分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        //        cell.config(title: animations[indexPath.row], imageName: animationImages[Int(arc4random() % 10)]) // 随机数  0 - 9
        cell.config(title: "\(indexPath.row)", imageName: "s1")
        return cell
    }
}
