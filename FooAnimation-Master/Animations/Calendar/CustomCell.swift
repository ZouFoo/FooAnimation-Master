//
//  CustomCell.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/8.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CustomCell: JTAppleCell {

    lazy var label: UILabel = {
        let _label = UILabel(frame: CGRect(x: 0, y: (frame.size.height - 20)/2, width: frame.size.width, height: 20))
        _label.font = UIFont.systemFont(ofSize: 15)
        _label.textColor = .black
//        _label.layer.borderWidth = 2
        _label.textAlignment = .center
        
        return _label
    }()
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: (frame.size.width - 40)/2, y: (frame.size.height - 40)/2, width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .yellow
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(label)
//        self.backgroundColor = .green

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
