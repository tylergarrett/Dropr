//
//  NewDotViewController.swift
//  Dropr
//
//  Created by Josh Peters on 4/11/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//

// Citing code from: http://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
// for dropping pin at user location

// Imgur API info:
// client id: 8b1d97aa17b0319
// client secret: d9dc5f9e658d93528ca3d1f9d0659d7d6c047f72

import UIKit
import MobileCoreServices
import CoreLocation

let imgurAPIkey = "8b1d97aa17b0319"
let imgurAPIurl = "https://api.imgur.com/3/image/"
var imagePathRet2:String = ""

class NewDotViewController: UIViewController, UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    //@IBOutlet weak var switchy: UISwitch!
    @IBOutlet weak var dotColor: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var switchy2: UISegmentedControl!
    var newMedia: Bool?
    var dot:Dot?
    
    // Code from our core skills app
    //take photo button
    @IBAction func takePhoto(_ sender: AnyObject) {

        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = true
        }
    }
    
    //use image library button
    @IBAction func useImageLibrary(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = false
        }
    }
    
    //image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(NewDotViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    //cancel on image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    //cancel on creating new dot
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // Code sourced from: https://brotherlemon.com/stories-facebook-swift-imgur/
    //     ....     and https://stackoverflow.com/questions/37812286/swift-3-urlsession-shared-ambiguous-reference-to-member-datataskwithcomplet
    func postImage(title:String, description:String, image:UIImage) -> String{
        // image path to return
        var imagePathRet = ""
        
        //First we will get the URL from the provided String by using GUARD, to ensure that we won't attempt to proceed with a wrong URL.
        guard let url = NSURL(string: imgurAPIurl) else {
            print("Error: cannot create URL")
            return "error"
        }
        
        //Create url request to send to Imgur
        let urlRequest = NSMutableURLRequest(url: url as URL)
        urlRequest.httpMethod = "POST"
        
        //Convert the passed image from UIImage to NSData
        let imageData: NSData = UIImageJPEGRepresentation(image, 1.0)! as NSData
        
        //The following part builds up the message that we will send to Imgur, I [article author] pretty much copied that part from a ObjC tutorial
        let requestBody: NSMutableData = NSMutableData()
        let boundary: String = "---------------------------0983745982375409872438752038475287"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        // Add client ID as auth header
        urlRequest.addValue("Client-ID \(imgurAPIkey)", forHTTPHeaderField: "Authorization")
        // Image File Data
        requestBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        requestBody.append("Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n".data(using: String.Encoding.utf8)!)
        requestBody.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
        requestBody.append(NSData(data: imageData as Data) as Data)
        requestBody.append("\r\n".data(using: String.Encoding.utf8)!)
        // Title parameter
        if title != "" {
            requestBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            requestBody.append(String(format: "Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8)!)
            requestBody.append(title.data(using: String.Encoding.utf8)!)
            requestBody.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        // Description parameter
        if description != "" {
            requestBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            requestBody.append(String(format: "Content-Disposition: form-data; name=\"description\"\r\n\r\n").data(using: String.Encoding.utf8)!)
            requestBody.append(description.data(using: String.Encoding.utf8)!)
            requestBody.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        requestBody.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        urlRequest.httpBody = requestBody as Data
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest)  { data, response, error in
            guard let data = data, error == nil else {
                print("erro on data")
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            // get uri from response JSON
            if let responseJSON = responseJSON as? [String: Any] {
                let dotResponseJSON = responseJSON["data"] as? [String: Any]
                //set dot's uri
                let imagePath = imgurAPIurl + (dotResponseJSON!["id"]! as! String)
                //imagePathGlobal = imagePath
                print(imagePath)
                imagePathRet = (dotResponseJSON!["id"]! as! String)
                imagePathRet2 = (dotResponseJSON!["id"]! as! String)
                print(imagePathRet2 + "please work")
            }
        }
        task.resume()
        print("did the post")
        print("image path in post img function")
        print(imagePathRet)
        return imagePathRet
    }

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Get user location
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
    }
    
    @IBAction func addDot(_ sender: Any) {
        // check for empty fields: http://stackoverflow.com/questions/29633938/swift-displaying-alerts-best-practices
        if titleTextField.text == "" {
            let alertController = UIAlertController(title: "No title", message: "Please add a title.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if descriptionTextField.text == "" {
            let alertController = UIAlertController(title: "No description", message: "Please add a description.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (titleTextField.text?.characters.count)! > 40{
            let alertController = UIAlertController(title: "Title too long", message: "Please shorten the title to 40 characters or less.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if imageView.image == nil {
            let alertController = UIAlertController(title: "Add image", message: "Please select an image to attach to your Dot.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (descriptionTextField.text?.characters.count)! > 140 {
            let alertController = UIAlertController(title: "Description too long", message: "Please shorten the description to 140 characters or less.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "AddDot", sender: self)
        }
    }
    

    
    // Segue for dropping that dot
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "AddDot"{
            // check for empty fields: http://stackoverflow.com/questions/29633938/swift-displaying-alerts-best-practices
            if titleTextField.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please add a title", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            // get image
            let image = imageView.image
            imagePathRet2 = postImage(title: titleTextField.text!, description: descriptionTextField.text!, image: image!)
            print("path segue")
            //print(path)
            
            sleep(5)
            //need to change imagePath, add green indicator, and add user location
            dot = Dot(title: titleTextField.text!, desc: descriptionTextField.text!, upVoteCount: 0, imagePath: imagePathRet2, green: selectColor(), coordinate: locValue, deviceID: deviceID)
            
            print("dot green status in newdotVC before segue",dot!.green)
            print(imagePathRet2)
        }
        
    }
    
    //from https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func selectColor() -> Bool {
        if switchy2.selectedSegmentIndex == 0 {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDotViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        //from https://stackoverflow.com/questions/29312447/how-to-set-uisegmentedcontrol-tint-color-for-individual-segment
        let subViewOfSegment: UIView = switchy2.subviews[0] as UIView
        let subViewOfSegment2: UIView = switchy2.subviews[1] as UIView
        subViewOfSegment.tintColor = hexStringToUIColor(hex:"C0392B")
        subViewOfSegment2.tintColor = hexStringToUIColor(hex:"2ECC71")
        
        
        addButton.backgroundColor = hexStringToUIColor(hex:"3498db")
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
