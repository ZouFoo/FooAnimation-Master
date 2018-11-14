//
//  WebPreviewViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/11/6.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit

class WebPreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 50 , width: 40, height: 40))
        closeButton.setTitle("关闭", for: .normal)
        closeButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        self.view.addSubview(closeButton)
        let webView = UIWebView.init(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 500))
        self.view.addSubview(webView)
        webView.loadRequest(URLRequest(url: URL(string: "https://res-crm.papitube.com/6204faf23e58df01.xlsx")!))
        
        
    }
    
    
    @objc func closeWebView() {
        self.dismiss(animated: true, completion: nil)
    }
    

}
