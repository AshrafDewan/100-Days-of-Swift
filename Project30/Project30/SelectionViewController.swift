//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false
    //3
    var images = [UIImage?]()
    //
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //3
        DispatchQueue.global().async { [weak self] in
            self?.loadImages()
        }
    }
    //3
    func loadImages() {
        // load all the JPEGs into our array
        let fm = FileManager.default
        //1
        guard let path = Bundle.main.resourcePath else { return }
        //
        if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                    if let image = load(name: item) {
                        images.append(image)
                    } else {
                       images.append(loadThumbnail(item))
                    }
                }
            }
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func loadThumbnail(_ currentImage: String) -> UIImage? {
        //let currentImage = items[indexPath.row % items.count]
        let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
        //1
        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else { return nil }
        guard let original = UIImage(contentsOfFile: path) else { return nil }
        //
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()
            
            original.draw(in: renderRect)
        }
        
        save(name: currentImage, image: rounded)
        
        return rounded
    }
    
    func save(name:String, image: UIImage) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        
        if let pngData = image.pngData() {
            try? pngData.write(to: imagePath)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func load (name: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage.init(contentsOfFile: path.path)
    }
    //
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if images.isEmpty {
            return 0
        } else {
            return items.count * 10
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
        //3
        let index = indexPath.row % items.count
        guard let rounded = images[index] else { return cell }
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
		cell.imageView?.image = rounded
        //
		// give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: items[index]))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false
        //1
        navigationController?.pushViewController(vc, animated: true)
        //
	}
}
