//
//  MineViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/16.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import pop

class MineViewController: UIViewController {

    
    var isBegin = false
    
    
    //动画播放时间
    var duration:CFTimeInterval = 1
    
    //运动的方块
    var square:UIView!
    
    //绘制路线的图层
    var pathLayer:CAShapeLayer!
    
    
    
    lazy var timeLabel: UILabel = {
        let _label = UILabel(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        _label.font = UIFont.systemFont(ofSize: 20)
        _label.textColor = .white
        _label.text = "00:00.00"
        
        return _label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        // Do any additional setup after loading the view.
        
        
        self.view.addSubview(timeLabel)
        
        
    
        let timeButton = UIButton(frame: CGRect(x: 200, y: 100, width: 100, height: 50))
        timeButton.backgroundColor = .red
        timeButton.addTarget(self, action: #selector(beginTime), for: .touchUpInside)
        self.view.addSubview(timeButton)
        
        
        
//        connectionPoint()
//        self.drawLine()
    }
    
    func drawLine() {
        //初始化方块
        square = UIView(frame:CGRect(x:0, y:0, width:20, height:20))
        square.backgroundColor = UIColor.green
        
        //设置运动的路线
        let centerX = view.bounds.size.width/2
        //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
        let transform = CGAffineTransform(translationX: centerX, y: 200)
        let path =  CGMutablePath()
        path.move(to: CGPoint(x:0 ,y:0), transform: transform)
        path.addLine(to: CGPoint(x:0 ,y:75), transform: transform)
        path.addLine(to: CGPoint(x:75 ,y:75), transform: transform)
        path.addArc(center: CGPoint(x:0 ,y:75), radius: 75, startAngle: 0,
                    endAngle: CGFloat(1.5 * .pi), clockwise: false, transform: transform)
        
        //给方块添加移动动画
        let orbit = CAKeyframeAnimation(keyPath:"position")
        orbit.duration = duration
        orbit.path = path
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.isRemovedOnCompletion = false
        orbit.fillMode = CAMediaTimingFillMode.forwards
        square.layer.add(orbit,forKey:"Move")
        
        //绘制运动轨迹
        pathLayer = CAShapeLayer()
        pathLayer.frame = self.view.bounds
        //pathLayer.isGeometryFlipped = true
        pathLayer.path = path
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.black.cgColor
        
        //给运动轨迹添加动画
        let pathAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        pathAnimation.duration = duration
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        //pathAnimation.delegate = (window as! CAAnimationDelegate)
        pathLayer.add(pathAnimation , forKey: "strokeEnd")
        
        //将轨道添加到视图层中
        self.view.layer.addSublayer(pathLayer)
        //将方块添加到视图中
        self.view.addSubview(square)
    }
    
    @objc func beginTime() {
        let propp: POPAnimatableProperty = POPAnimatableProperty.property(withName: "Custom") { (prop) in
            prop!.writeBlock = {(obj, value) -> Void in
                let lable = obj as! UILabel
                lable.text = String.init(format: "%02d:%02d.%02d", Int(value![0]/60) , Int(value![0].truncatingRemainder(dividingBy: 60)), Int((value![0] * 100).truncatingRemainder(dividingBy: 100)))
            }
            // 阈值
            // prop!.threshold = 0.01
            } as! POPAnimatableProperty
        let anBasic = POPBasicAnimation.init()
                anBasic.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        anBasic.property = propp
        anBasic.fromValue = 0
        anBasic.toValue = 180  //
        anBasic.duration = 180

        if isBegin == false {
            isBegin = true
            timeLabel.pop_add(anBasic, forKey: "Custom")
        }else{
            isBegin = false
            timeLabel.pop_removeAnimation(forKey: "Custom")
        }
    }


    
    
    func connectionPoint() {
        
        let points = [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]]
        
        //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
        let transform = CGAffineTransform(translationX: 20, y: 200)
        let path =  CGMutablePath()
        path.move(to: CGPoint(x:0 ,y:0), transform: transform)
        var lastArr = [0,0]
        for ps in points{
            if abs(ps[0] - lastArr[0]) + abs(ps[1] - lastArr[1])  < 2 {
                lastArr = ps
                path.addLine(to: CGPoint(x:ps[0] * 50 ,y:ps[1] * 50), transform: transform)
            }
        }
        
        //绘制运动轨迹
        pathLayer = CAShapeLayer()
        pathLayer.frame = self.view.bounds
        //pathLayer.isGeometryFlipped = true
        pathLayer.path = path
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.black.cgColor
        
        //给运动轨迹添加动画
        let pathAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        pathAnimation.duration = duration
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        //pathAnimation.delegate = (window as! CAAnimationDelegate)
        pathLayer.add(pathAnimation , forKey: "strokeEnd")
        
        //将轨道添加到视图层中
        self.view.layer.addSublayer(pathLayer)
       

        
    }
    
    
    
    
    
    
}
