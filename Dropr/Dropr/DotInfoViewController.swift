//
//  DotInfoViewController.swift
//  Dropr
//
//  Created by Josh Peters on 4/12/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//
// This helped us with segue & label values: http://stackoverflow.com/questions/25422536/swift-prepareforsegue-fatal-error-unexpectedly-found-nil-while-unwrapping-an

import UIKit
import Social

class DotInfoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
        
    // share text: http://stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
//    @IBAction func shareButton(_ sender: Any) {
//        // text to share
//        let text = "This is some text that I want to share."
//        
//        // set up activity view controller
//        let textToShare = [ text ]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//        
//        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = []
//        
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
//    }
    
    // Variables to hold segue text before loading view -> preventing  finding nil while unwrapping Optional values
    var titleText: String = ""
    var descText: String = ""
    var votes: Int = 0
    var deviceIDText = 0
    var uri:String = ""
    var imagePath = ""
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let part2 = uri
        var firstTodoUrlRequest = URLRequest(url: URL(string: baseURL + part2)!)
        firstTodoUrlRequest.httpMethod = "DELETE"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: firstTodoUrlRequest) {
            (data, response, error) in
            guard let _ = data else {
                print("data")
                return
            }
            print("DELETE ok")
        }
        task.resume()
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBOutlet weak var deleteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set label values
        titleLabel.text = titleText
        descriptionLabel.text = descText
        if(deviceIDText != deviceID){
            deleteButton.isHidden = true
        }
        let url = URL(string: "https://i.imgur.com/" + imagePath + ".jpg")
        print(url!)
        let data = try? Data(contentsOf: url!)
        // source: nshipster.com/image-resizing/
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(data: data!)
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
