//
//  HomeCollectionViewCell.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/9/28.
//  Copyright © 2018年 ZouFoo. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    lazy var backImage: UIImageView = {
        let _imageView = UIImageView(frame: self.bounds)
        _imageView.contentMode = .scaleAspectFit
        
        return _imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let _label = UILabel(frame: CGRect(x: 0, y: frame.size.height-30, width: frame.size.width, height: 30))
        _label.font = UIFont.systemFont(ofSize: 16)
        _label.textColor = .black
        _label.backgroundColor = .white
        _label.textAlignment = .center
        
        return _label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backImage)
        addSubview(titleLabel)

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, imageName: String) {
        self.backImage.image = UIImage(named: imageName)
        self.titleLabel.text = title
    }
}
