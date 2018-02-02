//
//  ViewController.swift
//  FlickrFinder
//
//  Created by Yugandhara Lad More on 12/13/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Mark: - Properties
    
    var keyboardOnScreen = false
     let myLocationManager = CLLocationManager()
    
    
    let cllocation = CLLocation()
    
    //Creating an object reference of Class URLComponents
    
    
    //Outlets
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
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //Mark: - Search Actions
    
    @IBAction func searchByPhrase(_ sender: Any) {
        userDidTapView(self)
        setUIEnabled(false)
        if !phraseTextField.text!.isEmpty {
            //phraseTextField.text = "Seaching..."
            
            //Setting neccessary parameters
            let methodParameters: [String:AnyObject] = [Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey as AnyObject, Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod as AnyObject, Constants.FlickrParameterKeys.Text: phraseTextField.text! as AnyObject, Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch as AnyObject,
                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL as AnyObject,
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat as AnyObject,
                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback as AnyObject]
            displayImagesFromFlickrbySearch(methodParameters)
        }
        else {
            setUIEnabled(true)
            photoTitleLabel.text = "Empty"
        }
    }
    
    @IBAction func searchByLatLon(_ sender: UIButton) {
        
        userDidTapView(self)
        setUIEnabled(false)
        if isTextFieldValid(latitudeTextField) == true && isTextFieldValid(longitudeTextField) == true {
            let methodParameters : [String: AnyObject] = [Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey as AnyObject, Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod as AnyObject, Constants.FlickrParameterKeys.BoundingBox: bBoxString(latitudeTextField.text!, longitudeTextField.text!) as AnyObject, Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch as AnyObject, Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL as AnyObject,
                                                          Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat as AnyObject, Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback as AnyObject]
            displayImagesFromFlickrbySearch(methodParameters)
            print("heowldy" )
        } else {
            setUIEnabled(true)
            photoTitleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
        }
    }
   
    @IBAction func SearchByCurrentLocation(_ sender: UIButton) {
        userDidTapView(self)
        setUIEnabled(false)
        if true {
        myLocationManager.delegate = self
           
        //locationManager(myLocationManager, didUpdateLocations: CLLocation)
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        //For use in foreground
        //self.locationManager.requestAlwaysAuthorization()
        //Ask for Authorization from user
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.startUpdatingLocation()
        
        
        
     /*
        print("heowldy" )*/
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        print(locations)
        var currentLat = locations[0].coordinate.latitude
        var currentLong = locations[0].coordinate.longitude
        CreateMethodParameters(currentLat, currentLong)
       
    }
    
    func CreateMethodParameters(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) {
        let methodParameters : [String: AnyObject] = [Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey as AnyObject, Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod as AnyObject, Constants.FlickrParameterKeys.BoundingBox: bBoxString(String(lat), String(long)) as AnyObject, Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch as AnyObject, Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL as AnyObject,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat as AnyObject, Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback as AnyObject]
        displayImagesFromFlickrbySearch(methodParameters)
        
    }
    
    
    func bBoxString (_ latitude: String!, _ longitude: String!) -> String {
       
        let minLatCenter =  ((Double(latitude))! - Constants.Flickr.SearchBBoxHalfWidth)
        let maxLatCenter =  ((Double(latitude))! + Constants.Flickr.SearchBBoxHalfWidth)
        let minLonCenter =  ((Double (longitude))! - Constants.Flickr.SearchBBoxHalfHeight)
        let maxLonCenter =  ((Double (longitude))! + Constants.Flickr.SearchBBoxHalfHeight)
            
            return "\(minLonCenter),\(minLatCenter),\(maxLonCenter),\(maxLatCenter)"
    }
    
    func isTextFieldValid(_ textField: UITextField) -> Bool {
        if let newTextField = textField.text, let textFieldDouble = Double(newTextField), !(textField.text?.isEmpty)! {
            if (-180 < textFieldDouble && textFieldDouble < 180) || (-90 < textFieldDouble && textFieldDouble < 90) {
               print("true is it")
                return true
            }
        }
        print("false is it")
        return false
        
    }
    
    
    @IBAction func searchByCurrentLocation(_ sender: UIButton) {
        }
    
    //Displaying Images from Flickr
    private func displayImagesFromFlickrbySearch (_ methodParameters: [String:AnyObject]) {
        print(flickrURLFromParameters(methodParameters))
    }

    
    func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        //Creating an Object of the class URLCOmponent using the default initializer and assigned it to a variable called components
        var components = URLComponents()
        //Assigned Values to oject properties
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        
        // Assigning an array of the type URLQueryItem
        components.queryItems = [URLQueryItem]()
        
        //Creating queryItems and appending it to component to form the url
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value as? String)
            components.queryItems?.append(queryItem)
        }
        
        print(components.url!)
        return components.url!
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    @IBAction func userDidTapView(_ sender: Any) {
        resignFirstResponder(phraseTextField)
        resignFirstResponder(latitudeTextField)
        resignFirstResponder(longitudeTextField)
        
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
    
    /* func isTextFieldValid(_ textField: UITextField, forRange: (Double, Double)) -> Bool {
        
        if let value = Double(textField.text!), !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    func isValueInRange(_ value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    } */
    
    
    
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


