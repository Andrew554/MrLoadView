//
//  ViewController.swift
//  Mr.LoadView
//
//  Created by SinObjectC on 16/1/4.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImageView(frame: UIScreen.mainScreen().bounds)
        image.image = UIImage(named: "sidebar_bg")
        self.view.addSubview(image)
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.backgroundColor = UIColor.grayColor()
        btn.frame = CGRectMake(50, 420, 120, 40)
        btn.layer.cornerRadius = 15
        btn.setTitle("显示", forState: UIControlState.Normal)
        btn.addTarget(self, action: "showLoadView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        let btn2 = UIButton(type: UIButtonType.Custom)
        btn2.backgroundColor = UIColor.grayColor()
        btn2.frame = CGRectMake(220, 420, 120, 40)
        btn2.layer.cornerRadius = 15
        btn2.setTitle("关闭", forState: UIControlState.Normal)
        btn2.addTarget(self, action: "dismissLoadView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn2)
    }
    
    func showLoadView(sender: UIButton) {
        let loadView = MrLoadView.sharedInstance
//        loadView.message = "努力加载中..."
//        loadView.animationColor = UIColor.greenColor()
//        loadView.bottomColor = UIColor.grayColor()
        loadView.showLoadingViewWithBlur()
    }
    
    func dismissLoadView(sender: UIButton) {
        MrLoadView.sharedInstance.dismissLoadingViewWithBlur()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        MrLoadView.sharedInstance.dismissLoadingViewWithBlur()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

