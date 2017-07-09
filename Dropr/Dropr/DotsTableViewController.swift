//
//  DotsTableViewController.swift
//  Dropr
//
//  Created by Josh Peters on 4/11/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//

import UIKit
import os.log

var dotsArray = [Dot]()

class DotsTableViewController: UITableViewController {
    
    @IBAction func refreshButton(_ sender: Any) {
        let vc = DotMapViewController()
        vc.loadCurrentPins()
        self.tableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.tableView.register(DotsTableViewCell.self, forCellReuseIdentifier: "DotsTableViewCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dotsArray.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cellIdentifier = "DotsTableViewCell"
//        
//        print("-------------",cellIdentifier,"------------------")
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DotsTableViewCell  else {
//            fatalError("The dequeued cell is not an instance of DotsTablViewCell.")
//        }
//        
//        let dot = dots[indexPath.row]
//        
//        cell.titleLabel.text = dot.title
//        return cell
//        
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DotsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DotsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DotsTableViewCell.")
        }
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "DotsTableViewCell", for: indexPath) as! DotsTableViewCell
        let dot = dotsArray[indexPath.row]
        
        cell.titleLabel.text = dot.title
        let url = URL(string: "https://i.imgur.com/" + dot.imagePath + ".jpg")
        print("getting here: " + dot.imagePath)
        let data = try? Data(contentsOf: url!)
        cell.redGreenDotImageView.image = UIImage(data: data!)
        
        return cell
    }
    
    
    
    func addNewDot(newDot: Dot){
        //way 1
                let newIndexPath = IndexPath(row: dotsArray.count, section: 0)
                dotsArray.append(newDot)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        //way 2
//        dots.append(newDot)
//        self.tableView.beginUpdates()
//        self.tableView.insertRows(at: [IndexPath(row: dots.count-1, section: 0)], with: .automatic)
//        self.tableView.endUpdates()
        
        //this doesnt crash but they still dont show up
        //        DispatchQueue.main.async() {
        //            print("hello")
        //            self.tableView.reloadData()
        //        }
        
        //this line crashes the program
        self.tableView.reloadData()
    }
    

    //not sure what this is
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    //not sure what this is
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 */
 
    // MARK: - Navigation
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "toInfo", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfo" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                let dot = dotsArray[selectedIndexPath.row]
                //brings up the info of the selected dot in the info screen
                let title = dot.title
                let desc = dot.desc
                let votes = dot.upVoteCount
                let deviceID = dot.deviceID
                let uri = dot.uri
                let imageP = dot.imagePath
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

    }

}
