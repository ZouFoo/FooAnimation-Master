//
//  ViewController.swift
//  TestGItFlow
//
//  Created by Michael_Zou on 2018/1/13.
//  Copyright © 2018年 Michael_Zou. All rights reserved.
//

import UIKit

let SCREENWIDTH = UIScreen.main.bounds.width

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    lazy var table: UITableView = {
        let _table = UITableView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENWIDTH) , style: .plain)
        
        _table.delegate = self
        _table.dataSource = self
        
        return _table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(table)
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = "indexPath = \(indexPath.row)"
        return cell!
    }


}

