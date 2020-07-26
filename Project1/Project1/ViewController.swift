//
//  ViewController.swift
//  Project1
//
//  Created by Ashraf Dewan on 4/6/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    //3
    var imageNumber = 0
    var totalNumber = 0
    //P12 -> 1
    var pictureCount = [String: Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        //P3 -> 2
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareApp))
        //P9 -> 1
        performSelector(inBackground: #selector(loadPictures), with: nil)
        //P12 -> 1
        let defaults = UserDefaults.standard
        pictureCount = defaults.object(forKey: "PictureNumber") as? [String: Int] ?? [String: Int]()
        //
    }
    //P9 -> 1
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        //2
        pictures.sort()
        //3
        totalNumber = pictures.count
        //
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        //3
        imageNumber = indexPath.row + 1
        cell.textLabel?.text = "Picture \(imageNumber) of \(totalNumber)"
        //P12 -> 1
        cell.detailTextLabel?.text = "Viewed: \(pictureCount[pictures[indexPath.row], default: 0])"
        //
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            //3
            imageNumber = indexPath.row + 1
            vc.title = "Picture \(imageNumber) of \(totalNumber)"
            //P12 -> 1
            pictureCount[pictures[indexPath.row], default: 0] += 1
            savePicturesViewCount()
            tableView.reloadData()
            //
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    //P3 -> 2
    @objc func shareApp() {
        let share: [Any] = ["Awesome app!, You should share it"]
        let vc = UIActivityViewController(activityItems: share, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    //P12 -> 1
    func savePicturesViewCount() {
        let defaults = UserDefaults.standard
        defaults.set(pictureCount, forKey: "PictureNumber")
    }
    //
}

