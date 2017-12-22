//
//  ViewController.swift
//  FlickrFinder
//
//  Created by Yugandhara Lad More on 12/13/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Mark: - Properties
    
    var keyboardOnScreen = false
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latLonSearchButton: UIButton!
    @IBOutlet weak var currentLocationTextField: UITextField!
    @IBOutlet weak var currentLocationSearchButton: UIButton!
    
    //Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        currentLocationTextField.delegate = self
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    @IBAction func userDidTapView(_ sender: Any) {
        resignFirstResponder(phraseTextField)
        resignFirstResponder(latitudeTextField)
        resignFirstResponder(longitudeTextField)
        resignFirstResponder(currentLocationTextField)
    }
    


}

//Mark: - ViewController: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    //Mark: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification)  {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)  {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification)  {
        keyboardOnScreen = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification)  {
        keyboardOnScreen = false
    }
    
    func resignFirstResponder(_ textField: UITextField)  {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    //Mark: - TextField Validation
    
    func isTextFieldValid(_ textField: UITextField, forRange: (Double, Double)) -> Bool {
        
        if let value = Double(textField.text!), !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    func isValueInRange(_ value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
    
    
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}


//Mark: - ViewController (Notifications)

private extension ViewController {
    func subscribeToNotification(_ notification: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications()  {
        NotificationCenter.default.removeObserver(self)
    }
}

//Mark: - ViewController (Configure UI)

private extension ViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        phraseTextField.isEnabled = enabled
        latitudeTextField.isEnabled = enabled
        longitudeTextField.isEnabled = enabled
        phraseSearchButton.isEnabled = enabled
        latLonSearchButton.isEnabled = enabled
        currentLocationTextField.isEnabled = enabled
        currentLocationSearchButton.isEnabled = enabled
        
        //Adjust search button alphas
        if enabled {
            phraseSearchButton.alpha = 1.0
            latLonSearchButton.alpha = 1.0
            currentLocationSearchButton.alpha = 1.0
        } else {
            phraseSearchButton.alpha = 0.5
            latLonSearchButton.alpha = 0.5
            currentLocationSearchButton.alpha = 0.5
        }
    }
}


