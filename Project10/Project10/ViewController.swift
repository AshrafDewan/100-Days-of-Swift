//
//  ViewController.swift
//  Project10
//
//  Created by Ashraf on 1/18/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //P28 -> 3
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var authenticateButton: UIButton!
    
    var tempPeople = [Person]()
    //
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //P28 -> 3
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(changeButtons), name: UIApplication.willResignActiveNotification, object: nil)
        
        addButton.isEnabled = false
        //
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage.init(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    @objc func addNewPerson() {
        let ac = UIAlertController(title: "Choose path", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Library", style: .default) {
            [weak self] _ in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        //2
        ac.addAction(UIAlertAction(title: "Camera", style: .default){
            [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = false
                self?.present(picker, animated: true, completion: nil)
            }
        })
        //
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        //P28 -> 3
        savePeople()
        //
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            //P28 -> 3
            self?.savePeople()
            //
            self?.collectionView.reloadData()
        })
        //1
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            //P28 -> 3
            self?.savePeople()
            //
            self?.collectionView.reloadData()
        })
        //
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    //P28 -> 3
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        addNewPerson()
    }
    
    @IBAction func authenticateButtonTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.title = ""
                        
                        self?.people = self?.tempPeople ?? [Person]()
                        self?.collectionView.reloadData()
                        
                        self?.authenticateButton.isHidden = true
                        self?.addButton.isEnabled = true
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You couldn't be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device isn't configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func changeButtons() {
        savePeople()
        
        people.removeAll()
        collectionView.reloadData()
        
        authenticateButton.isHidden = false
        addButton.isEnabled = false
        
        title = "Nothing to see here"
    }
    
    func savePeople() {
        guard authenticateButton.isHidden == true else { return }
        
        tempPeople = people
    }
    //
}

