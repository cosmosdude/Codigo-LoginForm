//
//  GenderSwitchView.swift
//  CDGO-IntProj-00
//
//  Created by Thwin Htoo Aung on 2022-05-21.
//

import UIKit

class GenderSwitchView: NibView {

    @IBOutlet private(set) var indicator: GradientView!
    @IBOutlet private(set) var innerIndicator: UIView!
    
    var gender: GenderType = .female {
        didSet {
            self.layoutIndicator()
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 1 {
        didSet { layoutInnerIndicator() }
    }
    
    @IBInspectable
    var padding: CGFloat = 0 {
        didSet { layoutIndicator() }
    }
    
    @IBInspectable
    var indicatorColor: UIColor! {
        set { indicator.backgroundColor = newValue }
        get { indicator.backgroundColor }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIndicator()
        
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
    }
    
    private func layoutIndicator() {
        indicator.frame.size = CGSize(
            width: (bounds.size.width / 2) - (padding * 2),
            height: bounds.size.height - (padding * 2)
        )
        
        indicator.layer.cornerRadius = min(
            indicator.frame.size.width, indicator.frame.size.height
        ) / 2
        
        indicator.frame.origin = CGPoint(
            x: (gender == .female ? 0 : frame.size.width / 2) + padding,
            y: padding
        )
        layoutInnerIndicator()
    }
    
    private func layoutInnerIndicator() {
        innerIndicator.frame.size = indicator.frame.size
        innerIndicator.frame.size.width -= lineWidth * 2
        innerIndicator.frame.size.height -= lineWidth * 2
        innerIndicator.frame.origin = .init(x: lineWidth, y: lineWidth)
        
        innerIndicator.layer.cornerRadius = min(
            innerIndicator.frame.size.width, innerIndicator.frame.size.height
        ) / 2
    }
    
    @IBAction
    private func whenTapped() {
        UIView.animate(withDuration: 0.25) {
            self.gender.toggle()
        }
        
    }
    
}

extension GenderSwitchView {
    
    enum GenderType {
        case female, male
        
        mutating func toggle() {
            switch self {
            case .female: self = .male
            case .male: self = .female
            }
        }
        
    }
    
}
