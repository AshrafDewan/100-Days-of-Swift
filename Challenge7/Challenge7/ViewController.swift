//
//  ViewController.swift
//  Challenge7
//
//  Created by Ashraf Dewan on 5/13/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notesDict = [String: String]()
    var notesNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        let defaults = UserDefaults.standard
        
        if notesDict.isEmpty {
            notesDict = defaults.object(forKey: "Notes") as? [String: String] ?? [String: String]()
            notesNames = defaults.object(forKey: "NotesNames") as? [String] ?? [String]()
        }
    }
    
    @objc func addNote() {
        let ac = UIAlertController(title: "Create new note", message: "Name your note", preferredStyle: .alert)
        ac.addTextField { placeHolderText in
            placeHolderText.placeholder = "Enter note name"
        }
        ac.addAction(UIAlertAction(title: "Create", style: .default) { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            if name.isEmpty || name == " " {
                self?.noteNotCreated()
            } else if (self?.notesNames.contains(name))! {
                self?.existedNote()
            } else {
                self?.notesNames.append(name)
                self?.notesDict[name] = ""
                self?.tableView.reloadData()
                
                let defaults = UserDefaults.standard
                defaults.set(self?.notesDict, forKey: "Notes")
                defaults.set(self?.notesNames, forKey: "NotesNames")
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func noteNotCreated() {
        let ac = UIAlertController(title: "Note wasn't created", message: "You either didn't enter note name or entered an empty space.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Return", style: .cancel))
        present(ac, animated: true)
    }
    
    func existedNote() {
        let ac = UIAlertController(title: "Existed Note", message: "You already have a note with the same name.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Return", style: .cancel))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = notesNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            let name = notesNames[indexPath.row]
            vc.title = name
            vc.body = notesDict[name] ?? ""
            vc.notesNames = notesNames
            vc.notesDict = notesDict
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

