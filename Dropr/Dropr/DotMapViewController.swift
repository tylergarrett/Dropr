//
//  DotMapViewController.swift
//  Dropr
//
//  Created by Josh Peters on 4/12/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var deviceID = 0
let baseURL = "https://dropr-api.herokuapp.com"
//let baseURL = "http://localhost:5000"

class DotMapViewController: UIViewController, CLLocationManagerDelegate {
    
    var dot:Dot?
    var vc = DotsTableViewController()
    var dotArray = [Dot]()
    let userDefaults = UserDefaults.standard
    //var deviceID =
    @IBOutlet weak var addButton: UIButton!

    
    
    // Location manager
    let locationManager = CLLocationManager()
    // Outlet so MKMapView doesn't crash on load
    @IBOutlet weak var mapView: MKMapView!
    
    //create initial pre populated  dots
//    let dot1 = Dot(title: "Free food", desc: "There is currently free food at clem! Come and get it", upVoteCount: 2, imagePath: "http://www.pngmart.com/files/1/Burger-Food-PNG.png", green: true, coordinate: CLLocationCoordinate2D(latitude: 38.036235, longitude: -78.506288))
//    let dot2 = Dot(title: "Pet a dog", desc: "My dog is here and wants to be petted", upVoteCount: 5, imagePath: "http://www.pngmart.com/files/1/Burger-Food-PNG.png", green: false, coordinate: CLLocationCoordinate2D(latitude: 38.034235, longitude: -78.506228))
    
    //request location access from user
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func unwindToMap(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewDotViewController, let dot = sourceViewController.dot {

            //prep json data
            
            let json = ["title": dot.title!, "desc": dot.desc, "upVoteCount": dot.upVoteCount, "imagePath": dot.imagePath, "green": dot.green, "latitude": dot.coordinate.latitude, "longitude": dot.coordinate.longitude, "deviceID": dot.deviceID] as [String: Any]
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            //let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            
            let url = URL(string: baseURL + "/dropr/api/v1.0/dots")!
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("erro on data")
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                // get uri from response JSON
                if let responseJSON = responseJSON as? [String: Any] {
                    let dotResponseJSON = responseJSON["dot"] as? [String: Any]
                    //set dot's uri
                    //dot.uri = dotResponseJSON!["uri"]! as! String
                    
                    //add dot to map and table
                    //self.mapView.addAnnotation(dot)
                    //vc.addNewDot(newDot: dot)
                }
            }
            task.resume()
            loadCurrentPins()
        }
        
//        if let sourceViewController = sender.source as? DotInfoViewController, let dot = sourceViewController.dot {
//            
//        }
    }
    
    func loadCurrentPins(){
        let urlString = baseURL + "/dropr/api/v1.0/dots"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on url")
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let json =  try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                    let dotsJsonArray = json["dots"] as? [[String: Any]]
                else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                dotsArray.removeAll()
                self.vc.self.tableView.reloadData()
                
                //turn the json into a dot and add it
                for i in 0..<dotsJsonArray.count {
                    let title = dotsJsonArray[i]["title"]! as! String
                    let desc = dotsJsonArray[i]["desc"]! as! String
                    let upVoteCount = dotsJsonArray[i]["upVoteCount"]! as! Int
                    let imagePath = dotsJsonArray[i]["imagePath"]! as! String
                    let green = dotsJsonArray[i]["green"] as! Bool
                    let latitude = dotsJsonArray[i]["latitude"] as! Double
                    let longitude = dotsJsonArray[i]["longitude"] as! Double
                    let uri = dotsJsonArray[i]["uri"] as! String
                    let deviceIDtemp = dotsJsonArray[i]["deviceID"] as! Int
                    
                    let tempDot = Dot(title: title, desc: desc, upVoteCount: upVoteCount, imagePath: imagePath, green: green, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), uri: uri, deviceID:deviceIDtemp)
                    if(self.mapView != nil){
                        self.mapView.addAnnotation(tempDot)
                    }
                    let vc = DotsTableViewController()
                    
                    if(deviceIDtemp == deviceID){
                        vc.addNewDot(newDot:tempDot)
                    }
                    
                
                }
                
            } catch  {
                print("error trying to convert data to JSON 2")
                print(error)
                return
            }
        }
        task.resume()
    }
    
    func reload(){
        
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
        loadCurrentPins()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check to see if a uni
        if(userDefaults.object(forKey: "deviceID") == nil){
            let randomNum:UInt32 = arc4random_uniform(1000000000)
            let randomDeviceID:Int = Int(randomNum)
            userDefaults.set(randomDeviceID, forKey: "deviceID")
            deviceID = randomDeviceID
        }
        else{
            deviceID = Int(userDefaults.string(forKey: "deviceID")!)!
        }

        requestLocationAccess()                 // requesting access to location
        mapView?.showsUserLocation = true       // show user's location
        mapView?.userTrackingMode = .follow     // follow the user
        loadCurrentPins()
        
        mapView.delegate = self                 // connecting extension
        
        //add dots to dot array in table
        //vc.addNewDot(newDot: dot1)
        //vc.addNewDot(newDot: dot2)
        
        let vc = NewDotViewController()
        
        addButton.backgroundColor = vc.hexStringToUIColor(hex:"3498db")
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
