//
//  IQKeyboardManagerViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/22.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TZImagePickerController
import SKPhotoBrowser
import JXPhotoBrowser
import HMSegmentedControl

class IQKeyboardManagerViewController: UIViewController {

    lazy var myTextField0: UITextField = {
        let myTextField = UITextField(frame: CGRect(x: 40, y: self.view.frame.size.height * 0.2, width: self.view.frame.size.width - 80, height: 30))
        
        myTextField.layer.borderColor = UIColor.orange.cgColor
        myTextField.layer.borderWidth = 1.0
        
        return myTextField
    }()
    
    lazy var myTextField1: UITextField = {
        let myTextField = UITextField(frame: CGRect(x: 40, y: self.view.frame.size.height * 0.4, width: self.view.frame.size.width - 80, height: 30))
        
        myTextField.layer.borderColor = UIColor.orange.cgColor
        myTextField.layer.borderWidth = 1.0
        // 某个文本框上不显示toolbar
        myTextField.inputAccessoryView = UIView()
        return myTextField
    }()
    
    lazy var myTextField2: UITextField = {
        let myTextField = UITextField(frame: CGRect(x: 40, y: self.view.frame.size.height * 0.6, width: self.view.frame.size.width - 80, height: 30))
        
        myTextField.layer.borderColor = UIColor.orange.cgColor
        myTextField.layer.borderWidth = 1.0
        
        return myTextField
    }()
    
    lazy var myTextField3: UITextField = {
        let myTextField = UITextField(frame: CGRect(x: 40, y: self.view.frame.size.height * 0.8, width: self.view.frame.size.width - 80, height: 30))
        
        myTextField.layer.borderColor = UIColor.orange.cgColor
        myTextField.layer.borderWidth = 1.0
        
        return myTextField
    }()

    lazy var showImage: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(x: (self.view.frame.size.width - (self.view.frame.size.height * 0.2 - 30)) / 2, y: (self.view.frame.size.height * 0.2) + 30, width: (self.view.frame.size.height * 0.2) - 30, height: (self.view.frame.size.height * 0.2) - 30))
//        _imageView.contentMode = <#UIViewContentMode#>
//        _imageView.image = UIImage(named: <#T##String#>)
        _imageView.backgroundColor = .green
        
        
        return _imageView
    }()
    
    lazy var photoBrowserButton: UIButton = {
        let _btn = UIButton(frame: CGRect(x: (self.view.frame.size.width - (self.view.frame.size.height * 0.2 - 30)) / 2, y: (self.view.frame.size.height * 0.4) + 30, width: (self.view.frame.size.height * 0.2) - 30, height: (self.view.frame.size.height * 0.2) - 30))
        _btn.setTitle("图片浏览", for: .normal)
        _btn.backgroundColor = .green
        _btn.addTarget(self, action: #selector(showImages), for: .touchUpInside)
        
        return _btn
    }()
    
    lazy var segmentedControl: HMSegmentedControl = {
        let segmentedControl = HMSegmentedControl(sectionTitles: ["one","two","three","four","one","two","three","four"])
        segmentedControl!.frame = CGRect(x: 0, y: (self.view.frame.size.height * 0.6) + 30, width: self.view.frame.size.width, height: 44)
        
        
        
        return segmentedControl!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "IQKeyboardManager"
        self.view.addSubview(myTextField0)
        self.view.addSubview(myTextField1)
        self.view.addSubview(myTextField2)
        self.view.addSubview(myTextField3)

        self.view.addSubview(showImage)
        self.view.addSubview(photoBrowserButton)
        self.view.addSubview(segmentedControl)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(selectPhotos))
    
    }

    
    
    //如果某个页面不想让键盘弹出
//    override func viewWillAppear(_ animated: Bool) {
//        //关闭自动键盘功能
//        IQKeyboardManager.shared.enable = false
//        //键盘上方toobar
//        IQKeyboardManager.shared.enableAutoToolbar = false
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        IQKeyboardManager.shared.enable = true
//
//    }
    
    
    
    @objc func selectPhotos() {
        let imagePickerView = TZImagePickerController(maxImagesCount: 9, columnNumber: 4, delegate: self)
        self.present(imagePickerView!, animated: true, completion: nil)
    
    }
    
    
    @objc func showImages() {

//        SKPhotoBrowser -----------------

        
//        var images = [SKPhoto]()
//        for index in 1...6{
//            let photo = SKPhoto.photoWithImage(UIImage(named:"s\(index)")!)// add some UIImage
//            images.append(photo)
//        }
//
//        // 2. create PhotoBrowser Instance, and present from your viewController.
//        let browser = SKPhotoBrowser(photos: images)
//
//        browser.initializePageIndex(0)
//        browser.delegate = self
//        self.present(browser, animated: true, completion: {})

        
//        JXPhotoBrowser -----------------
        // 创建图片浏览器
        
        
        let localDataSource = ["s1","s2","s3","s4","s5","s6"]
        // 数据源
        let dataSource = JXLocalDataSource(numberOfItems: {
            // 共有多少项
            return localDataSource.count
        }, localImage: { index -> UIImage? in
            // 每一项的图片对象
            return UIImage(named: localDataSource[index])
        })
        
        

        // 视图代理，实现了光点型页码指示器
        let pageDelegate = JXDefaultPageControlDelegate()
        pageDelegate.longPressedCallback = { browser, index, image, gesture in
            print("长按")
        }
        // 打开浏览器
//        JXPhotoBrowser(dataSource: dataSource).show(pageIndex: 5)
        let browser = JXPhotoBrowser(dataSource: dataSource, delegate: pageDelegate)
        browser.show(pageIndex: 3)
        
    }

    
}


extension IQKeyboardManagerViewController: SKPhotoBrowserDelegate{

}


// 图片选择器代理 TZImagePickerControllerDelegate
extension IQKeyboardManagerViewController: TZImagePickerControllerDelegate{
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        //
        if photos.count > 0 {
            self.showImage.image = photos[0]
        }
    }
}

