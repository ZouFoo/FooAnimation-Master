//
//  BaseViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/24.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
       
    }
    

}
