//
//  HtmlViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/11/5.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import WebKit

class HtmlViewController: UIViewController {

    
    lazy var webView: WKWebView = {
        
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self, name: "interOp")
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 90, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2), configuration: theConfiguration)
        webView.backgroundColor = .white
        
        return webView
    }()
    
    
    lazy var textFieldName: UITextField = {
        let textField = UITextField(frame: CGRect(x: 50, y: SCREEN_HEIGHT/2 + 100, width: 260, height: 20))
        textField.placeholder = "商品名"
        textField.backgroundColor = .white
        
        return textField
    }()
    
    lazy var textFieldPrice: UITextField = {
        let textField = UITextField(frame: CGRect(x: 50, y: SCREEN_HEIGHT/2 + 130, width: 260, height: 20))
        textField.placeholder = "价格"
        textField.backgroundColor = .white

        return textField
    }()
    
    lazy var textFieldCount: UITextField = {
        let textField = UITextField(frame: CGRect(x: 50, y: SCREEN_HEIGHT/2 + 160, width: 260, height: 20))
        textField.placeholder = "数量"
        textField.backgroundColor = .white

        return textField
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 50, y: SCREEN_HEIGHT/2 + 190, width: 260, height: 20))
        btn.setTitle("添加", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(useJS), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 10, y: 50, width: 40, height: 40))
        btn.setTitle("关闭", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.view.addSubview(webView)
        if let url = Bundle.main.url(forResource: "vue", withExtension: "html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        self.view.addSubview(textFieldName)
        self.view.addSubview(textFieldPrice)
        self.view.addSubview(textFieldCount)
        self.view.addSubview(addButton)
        self.view.addSubview(closeButton)

    }

    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func useJS() {
        
        if let name = self.textFieldName.text, let price = self.textFieldPrice.text, let count = self.textFieldCount.text {
//            self.webView.evaluateJavaScript("addToCar('\(name)','\(price)','\(count)'))",completionHandler: nil)
            self.webView.evaluateJavaScript("changeHead('\(name)','\(price)','\(count)')") { (any, error) in
                if error != nil {
                    print(error as Any)
                }
            }
        }else {
            print("信息不完整")
        }
    }
}


extension HtmlViewController: WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        ///在控制台中打印html中console.log的内容,方便调试
        let body = message.body
        if message.name == "interOp" {
            print("JS log:\(body)")
            
            if let jsonStr: String = body as? String{
                let jsonData = jsonStr.data(using: .utf8, allowLossyConversion: false)
                if let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers){
                    let dic = json as? NSDictionary
                    let alertController = UIAlertController(title: "JS传值", message: "\(dic!["name"]!)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
        return
    }
    
    
    
}



