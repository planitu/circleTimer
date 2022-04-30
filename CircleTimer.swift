//
//  CircleTimer.swift
//
//  Created by Максим 2022.
//

import UIKit

class CircleTimer: UIView {
    
    private var timer = Timer()
    private var radius: Int!
    private var colorCircle: UIColor!
    private var circleShapeLayer: CAShapeLayer!
        
    private var durationTimer = 1 {
        didSet {
            timerLabel.text = "\(Int(durationTimer))"
        }
    }
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    
// MARK:  - init
    init(center: CGPoint, radius: Int, color: UIColor) {
        super.init(frame: CGRect(origin: CGPoint(x: center.x - CGFloat(radius), y: center.y - CGFloat(radius)), size: CGSize(width: radius * 2, height: radius * 2)))
        self.colorCircle = color
        self.radius = radius
        self.backgroundColor = .clear
    
        timerLabel.font = UIFont.boldSystemFont(ofSize: Double(radius)*0.7)
        timerLabel.frame = CGRect(x: 0, y: 0, width: Double(radius)*1.4, height: Double(radius)*1.4)
        timerLabel.center = CGPoint(x: radius, y: radius)
        self.addSubview(timerLabel)
        
        self.circleShapeLayer = configureCircleLayer()
        self.layer.addSublayer(circleShapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
// MARK:   - Functions
    func startTimer(for seconds: Int) {
        durationTimer = seconds
     
        circleShapeLayer.add(createCircleAnimation(), forKey: "key")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        if durationTimer > 0 {
            durationTimer -= 1
        } else {
            stopTimer()
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        circleShapeLayer.strokeEnd = 0
    }
    
    
    // MARK:   - Cirlce
    
    private func configureCircleLayer() -> CAShapeLayer {
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circlePath()
        progressLayer.strokeColor = colorCircle.cgColor
        progressLayer.lineWidth = 18
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        return progressLayer
    }
    
    private func circlePath() -> CGPath {
        UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                     radius: CGFloat(radius),
                    startAngle: 2 * CGFloat.pi + (-CGFloat.pi / 2),
                    endAngle: (-CGFloat.pi / 2),
                    clockwise: false).cgPath
    }
    
    private func createCircleAnimation() -> CABasicAnimation {

        let strokeAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))

        strokeAnimation.toValue = 0
        strokeAnimation.fromValue = 1
        strokeAnimation.duration = CFTimeInterval(durationTimer)
        strokeAnimation.isRemovedOnCompletion = true
        circleShapeLayer.strokeEnd = 0
        return strokeAnimation
    }
}
