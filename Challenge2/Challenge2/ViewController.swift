//
//  ViewController.swift
//  Challenge2
//
//  Created by Ashraf on 1/4/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemsToSell = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        let addItemsButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(wantedItem))
        let shareButton = UIBarButtonItem(title: "Share list", style: .plain, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItems = [addItemsButton, shareButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startShopping))
        
        startShopping()
    }
    
    @objc func startShopping() {
        itemsToSell.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToSell.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = itemsToSell[indexPath.row]
        return cell
    }
    
    @objc func wantedItem() {
        let ac = UIAlertController(title: "Add the item you want to buy", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac!.textFields?[0].text else { return }
            if (self?.isOriginal(item))! {
                self?.itemsToSell.insert(item, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                let ac = UIAlertController(title: "Repeated item", message: "You already wrote this item in your list", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(ac, animated: true)
            }
        })
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        let list = itemsToSell.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func isOriginal(_ word: String) -> Bool {
        return !itemsToSell.contains(word)
    }
}

