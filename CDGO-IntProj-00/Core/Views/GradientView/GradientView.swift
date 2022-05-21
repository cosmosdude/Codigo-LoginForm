//
//  GradientView.swift
//  CDGO-IntProj-00
//
//  Created by Thwin Htoo Aung on 2022-05-21.
//

import UIKit

class GradientView: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    @IBInspectable var startColor: UIColor! = .clear {
        didSet {
            setGradient(start: startColor, end: endColor)
        }
    }
    
    @IBInspectable var endColor: UIColor! = .clear {
        didSet {
            setGradient(start: startColor, end: endColor)
        }
    }
    
    /// Gradient relative start point with respect to view's coordinate space.
    ///
    /// Default is `(0.5, 0)`.
    @IBInspectable var startPoint: CGPoint {
        set { gradientLayer.startPoint = newValue }
        get { gradientLayer.startPoint }
    }
    
    /// Gradient relative endpoint point with respect to view's coordinate space.
    ///
    /// Default is `(0.5, 1)`.
    @IBInspectable var endPoint: CGPoint {
        set { gradientLayer.endPoint = newValue }
        get { gradientLayer.endPoint }
    }
    
    private func setGradient(start: UIColor?, end: UIColor?) {
        
        let start = start ?? backgroundColor ?? .clear
        let end = end ?? backgroundColor ?? .clear
        
        gradientLayer.colors = [start.cgColor, end.cgColor]
        
    }
    
}
