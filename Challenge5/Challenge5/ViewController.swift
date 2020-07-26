//
//  ViewController.swift
//  Challenge5
//
//  Created by Ashraf on 2/23/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = ["Egypt", "Germany", "Italy", "France", "Canada", "Russia", "US", "UK"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Countries", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CountryDetails") as? DetailViewController {
            
            vc.title = countries[indexPath.row]
            vc.countryDetail = vc.countriesDetails[countries[indexPath.row]]!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

