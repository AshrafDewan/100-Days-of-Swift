//
//  ViewController.swift
//  Project1
//
//  Created by Ashraf on 12/12/19.
//  Copyright © 2019 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    var selectedImage = 0
    var totalNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
        totalNumber = pictures.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        selectedImage = indexPath.row + 1
        cell.textLabel?.text = "Picture \(selectedImage) of \(totalNumber)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            selectedImage = indexPath.row + 1
            vc.title = "Picture \(selectedImage) of \(totalNumber)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


