//
//  MrLoadView.swift
//  Mr.LoadView
//
//  Created by SinObjectC on 16/1/4.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

let MrLoadingViewWidth: CGFloat = 70
let MrShapeLayerWidth: CGFloat = 40
let MrShapeLayerRadius: CGFloat = MrShapeLayerWidth/2
let MrShapeLayerLineWidth: CGFloat = 2.5
let MrAnimationDurationTime: CGFloat = 1.5
let MrShapeLayerMargin: CGFloat = (MrLoadingViewWidth - MrShapeLayerWidth)/2
let MrLoadingTextColor: UIColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
let MrLoadingBottomColor: UIColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
let MrLoadingAnimationColor: UIColor = UIColor.redColor()

let MrLoadingText: String = "Mr正在努力加载中..."

/// Mr.洛洛的自定义加载动画

public class MrLoadView: UIView {
    private var blurView: UIVisualEffectView?
    private var isShowing: Bool = false
    private var titleLabel: UILabel?
    
    /// 动画圆底色
    public var bottomColor: UIColor = MrLoadingBottomColor {
        didSet {
            setUI()
        }
    }
    
    /// 动画颜色
    public var animationColor: UIColor = MrLoadingAnimationColor {
        didSet {
            setUI()
        }
    }
    
    var message: String = MrLoadingText {
        didSet{
            setUI()
        }
    }
    
    override public func awakeFromNib() {
        self.setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 创建动画单例
    class var sharedInstance: MrLoadView {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: MrLoadView? = nil
        }
        
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.instance = MrLoadView()
        }
        return Static.instance!
    }

    
    /**
     初始化UI布局
     */
    func setUI() {
        if(self.titleLabel != nil) {
            self.titleLabel!.removeFromSuperview()
        }
        
        // 底部的灰色layer
        let bottomShapeLayer = CAShapeLayer()
        bottomShapeLayer.strokeColor = self.bottomColor.CGColor
        bottomShapeLayer.fillColor = UIColor.clearColor().CGColor
        bottomShapeLayer.lineWidth = MrShapeLayerLineWidth
        // 图形的路径
        bottomShapeLayer.path = UIBezierPath(roundedRect: CGRect(x: MrShapeLayerMargin, y: 0, width: MrShapeLayerWidth, height: MrShapeLayerWidth), cornerRadius: MrShapeLayerRadius).CGPath
        self.layer.addSublayer(bottomShapeLayer)
        
        // 橘黄色的layer
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = self.animationColor.CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = MrShapeLayerLineWidth
        // 分割点效果
        ovalShapeLayer.lineDashPattern = [6, 3]
        ovalShapeLayer.path = UIBezierPath(roundedRect: CGRect(x: MrShapeLayerMargin, y: 0, width: MrShapeLayerWidth, height: MrShapeLayerWidth), cornerRadius: MrShapeLayerRadius).CGPath
        self.layer.addSublayer(ovalShapeLayer)
        
        //  起点动画
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -1
        strokeStartAnimation.toValue = 1.0

        //  终点动画
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0

        //  组合动画
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        animationGroup.duration = (Double)(MrAnimationDurationTime)
        animationGroup.repeatCount = (Float)(CGFloat.max)
        // 设置保存动画的最新状态
        animationGroup.fillMode = kCAFillModeForwards
        // 设置动画执行完毕之后不删除动画
        animationGroup.removedOnCompletion = false
        
        // 添加核心动画到layer
        ovalShapeLayer.addAnimation(animationGroup, forKey: nil)
        
        self.titleLabel = UILabel()
        self.titleLabel!.frame = CGRectMake(0, MrShapeLayerWidth + 5, MrLoadingViewWidth + 10, 30)
        self.titleLabel!.numberOfLines = 0
        self.titleLabel!.text = self.message
        self.titleLabel!.textColor = MrLoadingTextColor
        self.titleLabel!.font = UIFont.systemFontOfSize(12)
        self.titleLabel!.textAlignment = NSTextAlignment.Center

        self.addSubview(self.titleLabel!)
    }
    
    /**
     显示加载动画
     */
    func showLoadingView() {
        if(isShowing == true) {  // 如果没有退出动画， 就不能继续添加
            return
        }
        
        isShowing = true
        self.addSelfViewToWindow()
    }
    
    /**
     关闭加载动画
     */
    func dismissLoadingView() {
        if(isShowing == false) {
            return
        }
        
        isShowing = false
        self.removeFromSuperview()
    }
    
    /**
     显示加载动画（带毛玻璃效果）
     */
    func showLoadingViewWithBlur() {
        if(isShowing == true) { // 如果没有退出动画，就不能继续添加
            return
        }
        
        isShowing = true
        self.addSelfViewToWindow()
        
        // 拿到主窗口
        let window = UIApplication.sharedApplication().keyWindow
        // view的x
        let viewCenterX: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)/2
        // view的Y
        let viewCenterY: CGFloat = CGRectGetHeight(UIScreen.mainScreen().bounds)/2
        
        // 初始化模糊效果
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView?.layer.cornerRadius = 10
        blurView?.layer.masksToBounds = true
        blurView?.frame = CGRectMake(0, 0, 100, 100)
        blurView?.center = CGPointMake(viewCenterX, viewCenterY)
        
        /**
        添加毛玻璃效果
        */
        window?.insertSubview(blurView!, belowSubview: self)
    }
   
    /**
     关闭加载动画（带毛玻璃效果）
     */
    func dismissLoadingViewWithBlur() {
        if(isShowing == false) {
            return
        }
        
        isShowing = false
        blurView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    /**
     将本身添加到主窗口
     */
    func addSelfViewToWindow() {
        // 拿到主窗口
        let window = UIApplication.sharedApplication().keyWindow
        
        // view的x
        let viewCenterX: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)/2
        // view的Y
        let viewCenterY: CGFloat = CGRectGetHeight(UIScreen.mainScreen().bounds)/2
        
        self.frame = CGRectMake(0, 0, MrLoadingViewWidth, MrLoadingViewWidth)
        self.center = CGPointMake(viewCenterX, viewCenterY)
        
        // 添加到主窗口中去
        window?.addSubview(self)
    }
}
