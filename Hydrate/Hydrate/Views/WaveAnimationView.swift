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
    
}
