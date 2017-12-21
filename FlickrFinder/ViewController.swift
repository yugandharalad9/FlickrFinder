//
//  ViewController.swift
//  FlickrFinder
//
//  Created by Yugandhara Lad More on 12/13/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    @IBOutlet weak var phraseTextField: UITextField!
    
    @IBOutlet weak var phraseSearchButton: UIButton!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    


}

//Mark: - ViewController: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
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

