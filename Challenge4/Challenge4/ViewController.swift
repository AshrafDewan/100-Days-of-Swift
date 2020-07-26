//
//  ViewController.swift
//  Challenge4
//
//  Created by Ashraf on 2/16/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Camera photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pic", for: indexPath) as! PictureCell
        let picture = pictures[indexPath.row]
        cell.name.text = picture.name
        cell.picture.image = picture.image
        
        return cell
    }
    
    @objc func takePicture() {
        let ac = UIAlertController(title: "Take a picture", message: nil, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
//            [weak self] _ in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                let picker = UIImagePickerController()
//                picker.delegate = self
//                picker.sourceType = .camera
//                picker.allowsEditing = false
//                self?.present(picker, animated: true, completion: nil)
//            }
//        })
        ac.addAction(UIAlertAction(title: "Library", style: .default) {
            [weak self] _ in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let picture = Picture(name: "Unknown", image: image)
        pictures.append(picture)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        
        let ac = UIAlertController(title: "Picture option", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            guard let newName = ac.textFields?[0].text else { return }
            picture.name = newName
            self?.tableView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Take a look", style: .default) {
            [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedPicture = picture
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.pictures.remove(at: indexPath.row)
            self?.tableView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

