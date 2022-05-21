//
//  FormViewController+IBOutlets.swift
//  CDGO-IntProj-00
//
//  Created by Thwin Htoo Aung on 2022-05-21.
//

import Foundation
import UIKit


extension FormViewController {
    typealias Outlets = FormViewController_IBOutlets
}

@objc
class FormViewController_IBOutlets: NSObject {
    
    @IBOutlet private(set) var scrollView: UIScrollView!
    @IBOutlet private(set) var inputFields: [FormTextView]! = []
    
    @IBOutlet private(set) var dobButton: UIButton!
    @IBOutlet private(set) var dobSeparator: UIView!
    @IBOutlet private(set) var dobSelectorContainer: UIView!
    @IBOutlet private(set) var dobSelector: UIDatePicker!
    @IBOutlet private(set) var dobSelectorHeight: NSLayoutConstraint!
    
    @IBOutlet private(set) var genderSwitch: UIView!
    
    @IBOutlet private(set) var countryCodeField: UITextField!
    @IBOutlet private(set) var phoneNumberField: UITextField!
}
