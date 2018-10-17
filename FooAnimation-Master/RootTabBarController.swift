//
//  RootTabBarController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/16.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import pop

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationsVC = ViewController()
        let animationsNav = setNavigationController(controller: animationsVC, controllerTitle: "Foo_Animations", barTitle: "动画", barImage: "management", selectedImage: "management")
        
        let holdVC = HoldViewController()
        let holdNav = setNavigationController(controller: holdVC, controllerTitle: "", barTitle: "", barImage: "", selectedImage: "")
        
        let mineVC = MineViewController()
        let mineNav = setNavigationController(controller: mineVC, controllerTitle: "Mine", barTitle: "我的", barImage: "dashboard", selectedImage: "dashboard")
        
        
        
        self.viewControllers = [animationsNav, holdNav, mineNav]
        
        
        //自定义按钮
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, 5, 40, 40)];
//        [btn setImage:[UIImage imageNamed:@"tabbar_add"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(tabBarDidClickPlusButton) forControlEvents:UIControlEventTouchUpInside];
//        [self.tabBar addSubview:btn];
        let centerButton = UIButton(frame: CGRect(x: (self.view.frame.width - 40)/2, y: 5, width: 40, height: 40))
        centerButton.setImage(UIImage(named: "setting"), for: .normal)
        centerButton.addTarget(self, action: #selector(didtouchBarButton), for: .touchUpInside)
        
        self.tabBar.addSubview(centerButton)
    }

    
    func setNavigationController(controller: UIViewController, controllerTitle: String, barTitle: String, barImage: String, selectedImage: String) -> UINavigationController {
        controller.title = controllerTitle
        
        controller.tabBarItem.title = barTitle
        controller.tabBarItem.image = UIImage(named: barImage)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)

        let nav = UINavigationController(rootViewController: controller)
        return nav
    }
    
    var baseView: UIView? = nil
    
    @objc func didtouchBarButton() {
//        let alert = UIAlertController(title: "点击了", message: "success", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)

        self.baseView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.baseView?.backgroundColor = .yellow
        
        self.view.addSubview(self.baseView!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeView))
        self.baseView?.addGestureRecognizer(tapGesture)
        
        
        let actionButton = UIButton(frame: CGRect(x: 100, y: -50, width: 50, height: 50))
        actionButton.backgroundColor = .blue
        self.baseView?.addSubview(actionButton)
        
        let actionButton2 = UIButton(frame: CGRect(x: 200, y: -50, width: 50, height: 50))
        actionButton2.backgroundColor = .red
        self.baseView?.addSubview(actionButton2)
        
        let actionButton3 = UIButton(frame: CGRect(x: 300, y: -50, width: 50, height: 50))
        actionButton3.backgroundColor = .green
        self.baseView?.addSubview(actionButton3)
        
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        anim?.toValue = actionButton.frame.origin.y + 200
        // 弹力--晃动的幅度 (springSpeed速度)
        anim?.springBounciness = 15.0
        anim?.beginTime = CACurrentMediaTime()   // + 1.0 当前时间加1s
        actionButton.pop_add(anim, forKey: "position")
        let anim2 = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        anim2?.toValue = actionButton2.frame.origin.y + 200
        // 弹力--晃动的幅度 (springSpeed速度)
        anim2?.springBounciness = 20
        anim2?.beginTime = CACurrentMediaTime() + 0.1
        actionButton2.pop_add(anim2, forKey: "position")
        let anim3 = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        anim3?.toValue = actionButton3.frame.origin.y + 200
        // 弹力--晃动的幅度 (springSpeed速度)
        anim3?.springBounciness = 10
        anim3?.beginTime = CACurrentMediaTime() + 0.3
        actionButton3.pop_add(anim3, forKey: "position")

        
        

        
        
    }
    
    @objc func removeView() {
        self.baseView?.removeFromSuperview()
    }
}
