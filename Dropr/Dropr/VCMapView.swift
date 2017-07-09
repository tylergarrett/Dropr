//
//  VCMapView.swift
//  Dropr
//
//  Created by Josh Peters on 4/12/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//

import Foundation
import MapKit

extension DotMapViewController: MKMapViewDelegate {
    
    //from https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Dot {
            let identifier = "dotPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            //adds pin color
            view.pinTintColor = annotation.pinTintColor()
            return view
        }
        return nil
    }
    
    // Prepare the segue to carry information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfo" {
            //brings up the info of the selected dot in the info screen
            let title = dot!.title
            let desc = dot!.desc
            let votes = dot!.upVoteCount
            let deviceID = dot!.deviceID
            let uri = dot!.uri
            let imageP = dot!.imagePath
            let nav = segue.destination as! UINavigationController
            let info = nav.topViewController as! DotInfoViewController
            //let info = segue.destination as! DotInfoViewController
            info.titleText = title!
            info.descText = desc
            info.votes = votes
            info.deviceIDText = deviceID
            info.uri = uri
            info.imagePath = imageP
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //sets global varible dot to the dot that was pressed
        dot = view.annotation as? Dot
        // When info button is pressed, control will equal the view callout
        if control == view.rightCalloutAccessoryView {
            // Segue b/w DotMap and DotInfo views
            performSegue(withIdentifier: "toInfo", sender: self)
        }
    }
    
  
    
    
}








