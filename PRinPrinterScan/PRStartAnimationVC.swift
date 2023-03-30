//
//  PRStartAnimationVC.swift
//  PRinPrinterScan
//
//  Created by Joe on 2023/3/28.
//

import UIKit

class PRStartAnimationVC: UIViewController {
    
    private let radarAnimation = "radarAnimation"
    private var animationLayer: CALayer?
    private var animationGroup: CAAnimationGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //
        let leidaBgV = UIView()
        view.addSubview(leidaBgV)
        leidaBgV.backgroundColor = .clear
        leidaBgV.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
            $0.width.height.equalTo(96)
        }
        let first = makeRadarAnimation(showRect: CGRect(x: -30, y: -30, width: 156, height: 156), isRound: true)
        leidaBgV.layer.addSublayer(first)
        //
        //
        let connectImgV = UIImageView()
        connectImgV.contentMode = .scaleAspectFit
        view.addSubview(connectImgV)
        connectImgV.image = UIImage(named: "homemainprinter1")
        connectImgV.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
            $0.width.height.equalTo(96)
        }
    }
    

    private func makeRadarAnimation(showRect: CGRect, isRound: Bool) -> CALayer {
        // 1. 一个动态波
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = showRect
        // showRect 最大内切圆
        if isRound {
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height)).cgPath
        } else {
            // 矩形
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height), cornerRadius: 10).cgPath
        }
        shapeLayer.fillColor = UIColor(hexString: "#9CCAFF")!.cgColor
        // 默认初始颜色透明度
        shapeLayer.opacity = 0.0
        
        animationLayer = shapeLayer
        
        // 2. 需要重复的动态波，即创建副本
        let replicator = CAReplicatorLayer()
        replicator.frame = shapeLayer.bounds
        replicator.instanceCount = 4
        replicator.instanceDelay = 0.5
        replicator.addSublayer(shapeLayer)
        
        // 3. 创建动画组
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(floatLiteral: 1.0)  // 开始透明度
        opacityAnimation.toValue = NSNumber(floatLiteral: 0)      // 结束时透明底
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        if isRound {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0, 0, 0))      // 缩放起始大小
        } else {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))      // 缩放起始大小
            
        }
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0))      // 缩放结束大小
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, scaleAnimation]
        animationGroup.duration = 2       // 动画执行时间
        animationGroup.repeatCount = HUGE   // 最大重复
        animationGroup.autoreverses = false
        
        self.animationGroup = animationGroup
        
        shapeLayer.add(animationGroup, forKey: radarAnimation)
        
        return replicator
    }

}
