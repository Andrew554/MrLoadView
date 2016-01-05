# MrLoadView
自定义的进度加载提示组件
let loadView = MrLoadView.sharedInstance
        // 设置显示文字
        loadView.message = "努力加载中..."
        // 设置动画前景色
        loadView.animationColor = UIColor.greenColor()
        // 设置动画背景色
        loadView.bottomColor = UIColor.grayColor()
        // 显示带模糊效果的加载动画
        loadView.showLoadingViewWithBlur()
        
        // 关闭加载动画
         MrLoadView.sharedInstance.dismissLoadingViewWithBlur()
