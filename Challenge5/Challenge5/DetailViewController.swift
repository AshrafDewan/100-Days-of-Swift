//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Ashraf Dewan on 4/15/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var countriesDetails = [
        "Egypt": ["Cairo", "1,010,408 km2", "100,075,480", "Egyptian pound (E£)"],
        "Germany": ["Berlin", "357,022 km2", "83,149,300", "Euro (€)"],
        "Italy": ["Rome", "301,340 km2", "60,317,116", "Euro (€)"],
        "France": ["Paris", "640,679 km2", "67,076,000", "Euro (€)"],
        "Canada": ["Ottawa", "9,984,670 km2", "37,894,799", "Canadian dollar ($)"],
        "Russia": ["Moscow", "17,098,246 km2", "146,745,098", "Russian ruble (₽)"],
        "US": ["Washington, D.C.", "9,833,520 km2", "328,239,523", "United States dollar ($)"],
        "UK": ["London", "242,495 km2", "67,886,004", "Pound sterling"],
    ]
    
    var headLines = ["Capital: ", "Size: ", "Population: ", "Currency: "]
    
    var countryDetail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryDetail.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = headLines[indexPath.row] + countryDetail[indexPath.row]
        return cell
    }
}
