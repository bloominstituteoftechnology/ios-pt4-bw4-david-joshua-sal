//
//  WaveAnimationView.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/18/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

class WaveAnimationView: UIView {
    
    // Properties

    let frontWaveLine: UIBezierPath = UIBezierPath()
    let backWaveLine: UIBezierPath = UIBezierPath()
    let frontWaveLayer: CAShapeLayer = CAShapeLayer()
    let backWaveSubLayer: CAShapeLayer = CAShapeLayer()
    
    var timer = Timer()
    var drawSeconds: CGFloat = 0.0
    var drawElapsedTime: CGFloat = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat
    var xAxis: CGFloat
    var yAxis: CGFloat
    var maskLayer: CALayer?
    var waveHeight: CGFloat = 15.0 //3.0 .. about 50.0 are standard.
    var waveDelay: CGFloat = 300.0 //0.0 .. about 500.0 are standard.
    var frontColor: UIColor!
    var backColor: UIColor!
    
    //0.0 .. 1.0
    open var progress: Float {
        willSet {
            self.xAxis = self.height - self.height*CGFloat(min(max(newValue, 0),1))
        }
    }

    override init(frame: CGRect) {
        self.width = frame.width
        self.height = frame.height
        self.xAxis = floor(height/2)
        self.yAxis = 0.0
        self.progress = 0.5
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.frontColor = color
        self.backColor = color
    }
    
    public convenience init(frame: CGRect, frontColor: UIColor, backColor: UIColor) {
        self.init(frame: frame)
        self.frontColor = frontColor
        self.backColor = backColor
    }
    
    /// Draws the front and back wave animations
    /// - Parameter rect: A structure that contains the animation in a rectangle
    override func draw(_ rect: CGRect) {
        wave(layer: backWaveSubLayer, path: backWaveLine, color: backColor, delay: waveDelay)
        wave(layer: frontWaveLayer, path: frontWaveLine, color: frontColor, delay: 0)
    }
    
    
    /// Sets the height of the water animation based off of the point value.
    /// - Parameter point: Progress level as a Float (0.0-1.0)
    func setProgress(_ point: Float) {
        let setPoint:CGFloat = CGFloat(min(max(point, 0),1))
        self.progress = Float(setPoint)
    }
    
    /// Starts the water Animation. Must be called in viewDidLoad.
    func startAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(waveAnimation), userInfo: nil, repeats: true)
    }
    
    /// Stops the water Animation. Must be called in viewDidDissapear to prevent possible memory leaks.
    func stopAnimation() {
        timer.invalidate()
    }
    
    /// Notifies the system that the view’s contents need to be redrawn. Used with Timer.scheduledTimer to redraw wave animation.
    @objc private func waveAnimation() {
        self.setNeedsDisplay()
    }
    
    /// Sets the wave properties
    /// - Parameters:
    ///   - layer: CAShapeLayer for the wave
    ///   - path: UIBezierPath for the wave crest; the sin wave animation
    ///   - color: The wave color
    ///   - delay: Delay for wave animation. Can be used to delay a backWaveSubLayer by X value to produce multiple wave effects.
    @objc private func wave(layer: CAShapeLayer, path: UIBezierPath, color: UIColor, delay:CGFloat) {
        path.removeAllPoints()
        drawWave(layer: layer, path: path, color: color, delay: delay)
        drawSeconds += 0.009
        drawElapsedTime = drawSeconds*CGFloat(Double.pi)
        if drawElapsedTime >= CGFloat(Double.pi) {
            drawSeconds = 0.0
            drawElapsedTime = 0.0
        }
    }
    
    /// Draws the wave
    /// - Parameters:
    ///   - layer: CAShapeLayer for the wave
    ///   - path: UIBezierPath for the wave crest; the sin wave animation
    ///   - color: The wave color
    ///   - delay: Delay for wave animation. Can be used to delay a backWaveSubLayer by X value to produce multiple wave effects.
    func drawWave(layer: CAShapeLayer,path: UIBezierPath,color: UIColor,delay:CGFloat) {
        drawSin(path: path,time: drawElapsedTime/0.5, delay: delay)
        path.addLine(to: CGPoint(x: width+10, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        layer.fillColor = color.cgColor
        layer.path = path.cgPath
        self.layer.insertSublayer(layer, at: 0)
    }
    
    /// Draws the UIBezier sin wave
    /// - Parameters:
    ///   - path: The path for drawing the wave crest
    ///   - time: The time it takes to animate the path
    ///   - delay: The delay for drawing the path
    func drawSin(path: UIBezierPath, time: CGFloat, delay: CGFloat) {
        
        let unit:CGFloat = 100.0
        let zoom:CGFloat = 1.0
        var x = time
        var y = sin(x)/zoom
        let start = CGPoint(x: yAxis, y: unit*y+xAxis)
        
        path.move(to: start)
        
        var i = yAxis
        while i <= width+10 {
            x = time+(-yAxis+i)/unit/zoom
            y = sin(x - delay)/self.waveHeight
            
            path.addLine(to: CGPoint(x: i, y: unit*y+xAxis))
            
            i += 10
        }
    }
}
