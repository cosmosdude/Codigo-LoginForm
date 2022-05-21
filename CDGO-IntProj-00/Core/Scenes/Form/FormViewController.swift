//
//  FormViewController.swift
//  CDGO-IntProj-00
//
//  Created by Thwin Htoo Aung on 2022-05-21.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet private(set) var outlets: Outlets!
    
    var formatter: DateFormatter!
    var date: Date!
    
}

extension FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outlets.inputFields.forEach {
            $0.textField.delegate = self
        }
        
        outlets.countryCodeField.delegate = self
        outlets.phoneNumberField.delegate = self
        
        formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        outlets.dobSelector.maximumDate = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeForkeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeForKeyboardEvents()
    }
    
}


// MARK:- IBActions
extension FormViewController {
    
    @IBAction
    private func actionForBackNavigation(button: UIButton!) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction
    private func actionForCreateNewAccount(button: UIButton!) {
        // validate
    }
    
    @IBAction
    private func actionForDobDropDown(button: UIButton!) {
        toggleDobSelector()
        self.outlets.dobSelectorContainer.layoutIfNeeded()
    }
    
    @IBAction
    private func actionWhenValueChanged(in datePicker: UIDatePicker) {
        date = datePicker.date
        
        outlets.dobButton.setTitle(
            formatter.string(from: date),
            for: .normal
        )
    }
    
    private func toggleDobSelector() {
        let maxHeight: CGFloat = view.frame.size.width / 1.61
        let minheight: CGFloat = 0
        let height = outlets.dobSelectorHeight.constant
        outlets.dobSelectorHeight.constant = height == minheight ? maxHeight : minheight
    }
    
}

extension FormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let inputField = outlets.inputFields
            .filter { $0.textField === textField }
            .first
        
        switch inputField?.identifier ?? "" {
            case "firstname": focusInput(identifier: "lastname")
            case "lastname": focusInput(identifier: "email")
            case "email": focusInput(identifier: "nationality")
            case "nationality": focusInput(identifier: "country")
            case "country": _ = outlets.countryCodeField.becomeFirstResponder()
            default:
                if textField === outlets.countryCodeField {
                    outlets.phoneNumberField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
        }
        
        return false
    }
    
    func focusInput(identifier: String) {
        outlets.inputFields.forEach {
            if $0.identifier == identifier {
                $0.becomeFirstResponder()
            }
        }
    }
    
    
    
}




extension FormViewController {
    
    private var keyboardEvents: [Notification.Name: Selector] {
        [
            UIView.keyboardWillShowNotification: #selector(
                whenKeyboardWillShow(notification:)
            ),
            
            UIView.keyboardDidShowNotification: #selector(
                whenKeyboardDidShow(notification:)
            ),
            
            UIView.keyboardWillChangeFrameNotification: #selector(
                whenKeyboardWillChangeFrame(notification:)
            ),
            
            UIView.keyboardDidChangeFrameNotification: #selector(
                whenKeyboardDidChangeFrame(notification:)
            ),
            
            UIView.keyboardWillHideNotification: #selector(
                whenKeyboardWillHide
            ),
            
            UIView.keyboardDidHideNotification: #selector(
                whenKeyboardDidHide
            )
        ]
    }
    
    func subscribeForkeyboardEvents() {
        keyboardEvents.forEach {
            NotificationCenter.default.addObserver(
                self, selector: $0.value,
                name: $0.key, object: nil
            )
        }
    }
    
    func unsubscribeForKeyboardEvents() {
        keyboardEvents.forEach {
            NotificationCenter.default.removeObserver(
                self, name: $0.key, object: nil
            )
        }
    }
    
    private func keyboardFrame(from notification: Notification) -> CGRect? {
        guard let userinfo = notification.userInfo,
              let anyValue = userinfo[UIView.keyboardFrameBeginUserInfoKey],
              let rawValue = anyValue as? NSValue
        else { return nil }
        
        return rawValue.cgRectValue
    }
    
    @objc
    private func whenKeyboardWillShow(notification: Notification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        
        outlets.scrollView.contentInset.bottom = frame.size.height
    }
    
    @objc
    private func whenKeyboardDidShow(notification: Notification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        outlets.scrollView.contentInset.bottom = frame.size.height
    }
    
    @objc
    private func whenKeyboardWillChangeFrame(notification: Notification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        outlets.scrollView.contentInset.bottom = frame.size.height
    }
    
    @objc
    private func whenKeyboardDidChangeFrame(notification: Notification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        outlets.scrollView.contentInset.bottom = frame.size.height
    }
    
    @objc
    private func whenKeyboardWillHide() {
        outlets.scrollView.contentInset.bottom = 0
    }
    
    @objc
    private func whenKeyboardDidHide() {
        outlets.scrollView.contentInset.bottom = 0
    }
    
}
