//
//  FormTextView.swift
//  CDGO-IntProj-00
//
//  Created by Thwin Htoo Aung on 2022-05-21.
//

import UIKit

class FormTextView: NibView {

    @IBOutlet private(set) var label: UILabel!
    @IBOutlet private(set) var textField: UITextField!
    @IBOutlet private(set) var separator: UIView!
    
    @IBInspectable
    var identifier: String = ""
    
    @IBInspectable
    var title: String {
        set { label.text = newValue }
        get { label.text ?? "" }
    }
    
    @IBInspectable
    var separatorColor: UIColor {
        set { separator.backgroundColor = newValue }
        get { separator.backgroundColor ?? .clear }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder() || super.becomeFirstResponder()
    }
    
}
