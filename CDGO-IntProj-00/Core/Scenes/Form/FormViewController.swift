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

        configureTextFields()
        
        outlets.countryCodeField.delegate = self
        outlets.phoneNumberField.delegate = self
        
        formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        outlets.dobSelector.maximumDate = Date()
    }
    
    private func configureTextFields() {
        outlets.inputFields.forEach {
            $0.textField.delegate = self
        }
        configureNameField(outlets.firstnameField.textField)
        configureNameField(outlets.lastnameField.textField)
        outlets.emailField.textField.keyboardType = .emailAddress
    }
    
    private func configureNameField(_ textField: UITextField) {
        textField.autocapitalizationType = .words
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
        validate()
    }
    
    private func validate() {
        validateFirstName()
        validateLastName()
        validateEmail()
        validateDob()
        validateNationality()
        validateCountryOfResidence()
        validatePhoneNumber()
    }
    
    private func validateFirstName() {
        let field = outlets.firstnameField
        let text = field?.text ?? ""
        field?.separatorColor = text.isEmpty ? R.Colors.error : R.Colors.separator
    }
    private func validateLastName() {
        let field = outlets.lastnameField
        let text = field?.text ?? ""
        field?.separatorColor = text.isEmpty ? R.Colors.error : R.Colors.separator
    }
    private func validateEmail() {
        let field = outlets.emailField
        let text = field?.text ?? ""
        field?.separatorColor = isEmail(text) ? R.Colors.separator : R.Colors.error
    }
    
    private func isEmail(_ text: String) -> Bool {
        let basic = "([a-zA-Z][a-zA-Z0-9]*){1}([.][a-zA-Z\\d][a-zA-Z\\d_]*)*"
        let pattern =
        """
        ^\(basic)[@]\(basic)$
        """
        
        guard let regex = try? NSRegularExpression(
                pattern: pattern,
                options: .caseInsensitive
        ) else {
            print("Regex is failing")
            return false
        }
        
        return regex.firstMatch(
            in: text, options: [],
            range: NSMakeRange(0, (text as NSString).length)
        ) != nil
    }
    
    private func validateNationality() {
        let color = outlets.nationalityField.text.isEmpty
            ? R.Colors.error : R.Colors.separator
        outlets.nationalityField.separatorColor = color
    }
    
    private func validateCountryOfResidence() {
        let color = outlets.countryField.text.isEmpty
            ? R.Colors.error : R.Colors.separator
        outlets.countryField.separatorColor = color
    }
    
    private func validatePhoneNumber() {
        let regionCode = outlets.countryCodeField.text ?? ""
        let phone = outlets.phoneNumberField.text ?? ""
        
        var color = R.Colors.separator
        
        // if boths are empty, that's fine
        // but if any of them are not empty, we need to validate
        if !regionCode.isEmpty || !phone.isEmpty {
            if !isValidRegionCode(regionCode) || !isValidPhoneNumber(phone) {
                color = R.Colors.error
            }
        }
        
        outlets.phoneSeparator.backgroundColor = color
    }
    
    private func isValidRegionCode(_ code: String) -> Bool {
        guard let regex = try? NSRegularExpression(
                pattern: "^[+][\\d]{1,3}$", options: []
        ) else { print("Regex Failed") ; return  false }
        
        return regex.firstMatch(
            in: code, options: [],
            range: NSMakeRange(0, (code as NSString).length )
        ) != nil
    }
    
    private func isValidPhoneNumber(_ number: String) -> Bool {
        guard let regex = try? NSRegularExpression(
                pattern: "^[\\d]+$", options: []
        ) else { print("Regex Failed") ; return  false }
        
        return regex.firstMatch(
            in: number, options: [],
            range: NSMakeRange(0, (number as NSString).length )
        ) != nil
    }
    
    private func validateDob() {
        // hint error if date is not selected
        outlets.dobSeparator.backgroundColor = (date == nil) ? R.Colors.error : R.Colors.separator
    }
    
    @IBAction
    private func actionForDobDropDown(button: UIButton!) {
        toggleDobSelector()
        self.outlets.dobSelectorContainer.layoutIfNeeded()
    }
    
    private func toggleDobSelector() {
        let maxHeight: CGFloat = view.frame.size.width / 1.61
        let minheight: CGFloat = 0
        let height = outlets.dobSelectorHeight.constant
        outlets.dobSelectorHeight.constant = height == minheight ? maxHeight : minheight
    }
    
    @IBAction
    private func actionWhenValueChanged(in datePicker: UIDatePicker) {
        date = datePicker.date
        outlets.dobButton.setTitle(
            formatter.string(from: date),
            for: .normal
        )
    }
    
    
    
}

extension FormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusNextOrResign(with: textField)
        return false
    }
    
    private func focusNextOrResign(with textField: UITextField) {
        if textField === outlets.firstnameField.textField {
            outlets.lastnameField.becomeFirstResponder()
        }
        
        if textField === outlets.lastnameField.textField {
            outlets.emailField.becomeFirstResponder()
        }
        
        if textField === outlets.emailField.textField {
            outlets.nationalityField.becomeFirstResponder()
        }
        
        if textField === outlets.nationalityField.textField {
            outlets.countryField.becomeFirstResponder()
        }
        
        if textField === outlets.countryField.textField {
            outlets.countryCodeField.becomeFirstResponder()
        }
        
        if textField === outlets.countryCodeField {
            outlets.phoneNumberField.becomeFirstResponder()
        }
        
        if textField === outlets.phoneNumberField {
            textField.resignFirstResponder()
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
