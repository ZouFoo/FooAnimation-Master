//
//  EurekaViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/30.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import Eureka

class EurekaViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //表单form增加一个Section区域，区域名为First form
        form +++ Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {100}
            header.onSetupView = { view, _ in
                view.backgroundColor = .red
            }
            section.header = header
            }
            <<< TextRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateTimeRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
                $0.tag = "startTime"
                    
            }
            <<< DateTimeRow(){
                $0.title = "Date Row"
                $0.value = Date()
                $0.tag = "endTime"
                $0.dateFormatter?.dateFormat = "yyyy年MM月dd日 hh:mm"
            }
        
        
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(post), for: .touchUpInside)
    
    
    }
    
    
    @objc func post() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH-mm"
        let rowStartTime: DateTimeRow? = form.rowBy(tag: "startTime")
        print(dateFormatter.string(from: (rowStartTime?.value)!))
        let rowEndTime: DateTimeRow? = form.rowBy(tag: "endTime")
        print(dateFormatter.string(from: (rowEndTime?.value)!))
    }


}
