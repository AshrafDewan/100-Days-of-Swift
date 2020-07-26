//
//  ViewController.swift
//  Project4
//
//  Created by Ashraf on 12/24/19.
//  Copyright © 2019 Ashraf Dewan. All rights reserved.
//
//3
import UIKit
import WebKit

class ViewController: UITableViewController {
    
    var listedWebsites = ["google.com", "apple.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listedWebsites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        cell.textLabel?.text = listedWebsites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedSite = listedWebsites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
//
