//
//  WrittenScriptsViewController.swift
//  Extension
//
//  Created by Ashraf Dewan on 5/9/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

protocol LoaderDelegate {
    func loader(_ loader: WrittenScriptsViewController, didSelect script: String)
}

class WrittenScriptsViewController: UITableViewController {
    var scriptsDict = [String: String]()
    var scriptTitleArray = [String]()
    var delegate: LoaderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptTitleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WrittenScriptCell", for: indexPath)
        cell.textLabel?.text = scriptTitleArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.loader(self, didSelect: scriptsDict[scriptTitleArray[indexPath.row]]!)
    }
}
