//
//  TimerView.swift
//  PulBack
//
//  Created by Kh's MacBook on 7/31/21.
//

import UIKit




class TimerView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private let startPoint = CGFloat(-Double.pi / 2)
    private let endPoint = CGFloat(3 * Double.pi / 2)
    private var count = 0
    private var duration = 60
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    func createCircularPath(radius: CGFloat, lineWidth: CGFloat, bgLineColor: UIColor = .clear, progressColor: UIColor, firstDuration: Int) {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = bgLineColor.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
        duration = firstDuration
        
        
//        animationView.animation = Animation.named("reload")
//        self.addSubview(animationView)
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//
//        animationView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        animationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
//        animationView.animationSpeed = 0.5
//        animationView.loopMode = .playOnce
//        animationView.isHidden = true
//
        
        
    }
    
    func progressAnimation() {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = CFTimeInterval(duration)
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = true
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        
       
        
        count = duration
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if count == 0 {
               
                timer.invalidate()
                
                
                
            } else {
                count -= 1
            }
            
        }
    }
}
