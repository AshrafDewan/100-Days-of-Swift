//
//  ViewController.swift
//  Project28
//
//  Created by Ashraf Dewan on 4/1/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!
    //1
    var doneButton: UIBarButtonItem!
    //2
    var password = ""
    var setPasswordButton: UIBarButtonItem!
    var changePasswordButton: UIBarButtonItem!
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        //1
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
        //2
        setPasswordButton = UIBarButtonItem(title: "Set password", style: .plain, target: self, action: #selector(setPassword))
        changePasswordButton = UIBarButtonItem(title: "Change password", style: .plain, target: self, action: #selector(changePassword))
        //
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        //2
                        self?.password = KeychainWrapper.standard.string(forKey: "Password") ?? ""
                        self?.enterPassword()
                        //
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
    //2
    func enterPassword() {
        if password != "" {
            let ac = UIAlertController(title: "Enter Your password", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
                if ac?.textFields?[0].text == self?.password {
                    self?.unlockSecretMessage()
                } else {
                    self?.wrongPassword()
                }
            })
            present(ac, animated: true)
        } else {
            unlockSecretMessage()
        }
    }
    //
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        //2
        passwordItem()
        //
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        //1
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        //2
        KeychainWrapper.standard.set(password, forKey: "Password")
        //
        secret.isHidden = true
        //1
        navigationItem.leftBarButtonItem = nil
        //2
        navigationItem.rightBarButtonItem = nil
        //
        title = "Nothing to see here"
    }
    //2
    @objc func setPassword() {
        let ac = UIAlertController(title: "Set new password", message: "Enter new Password twice, make sure they are identical", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Set", style: .default, handler: { [weak self, weak ac] _ in
            if ac?.textFields?[0].text == ac?.textFields?[1].text {
                self?.password = (ac?.textFields?[0].text)!
                if self?.password != "" {
                    self?.passwordItem()
                }
            } else {
                self?.wrongPassword()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func changePassword() {
        let ac = UIAlertController(title: "Change current password", message: "Enter old password first,\nthen enter new password,\nthen re-enter the same new password.", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Change", style: .default) { [weak self, weak ac] _ in
            if (ac?.textFields?[0].text)! == self?.password {
                if (ac?.textFields?[1].text)! == (ac?.textFields?[2].text)! {
                    self?.password = (ac?.textFields?[1].text)!
                    self?.passwordItem()
                } else {
                    self?.wrongPassword()
                }
            } else {
                self?.wrongPassword()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func wrongPassword() {
        let ac = UIAlertController(title: "Wrong password", message: "Your password hasn't been set/changed cause fields weren't identical, Try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func passwordItem() {
        if password == "" {
            navigationItem.rightBarButtonItem = setPasswordButton
        } else {
            navigationItem.rightBarButtonItem = changePasswordButton
        }
    }
    //
}

