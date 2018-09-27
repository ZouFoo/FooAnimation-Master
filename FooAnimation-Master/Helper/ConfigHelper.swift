//
//  File.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/9/27.
//  Copyright © 2018年 ZouFoo. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height


public func dd(_ message: Any?, file: String = #file, function: String = #function, line: Int = #line ) {
    #if DEBUG
    print("\(message ?? "null") => \(function) \(file):\(line)")
    #endif
}
