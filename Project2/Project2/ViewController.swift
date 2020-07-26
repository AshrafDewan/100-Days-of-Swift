//
//  ViewController.swift
//  Project2
//
//  Created by Ashraf on 12/18/19.
//  Copyright © 2019 Ashraf Dewan. All rights reserved.
//
import UserNotifications
import UIKit

class ViewController: UIViewController {
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    //2
    var questionsNumber = 0
    //P12 -> 2
    var oldScore = 0
    var newScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria","poland", "russia", "spain", "uk", "us"]
        
        Button1.layer.borderWidth = 1
        Button2.layer.borderWidth = 1
        Button3.layer.borderWidth = 1
        
        Button1.layer.borderColor = UIColor.lightGray.cgColor
        Button2.layer.borderColor = UIColor.lightGray.cgColor
        Button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        //P3 -> 3
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Your score", style: .plain, target: self, action: #selector((yourScore)))
        //P12 -> 2
        let defaults = UserDefaults.standard
        oldScore = defaults.object(forKey: "oldScore") as? Int ?? 0
        //P21 -> 3
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSchedule))
    }
    //P21 -> 3
    @objc func showSchedule() {
        let ac = UIAlertController(title: "Set notification", message: "You can set notification for a week ahead  every 24 hours from your last time to let the game remind you to play.\nPlease register first.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Register", style: .default) { [weak self] _ in
            self?.registerLocal()
        })
        ac.addAction(UIAlertAction(title: "Schedule", style: .default) { [weak self] _ in
            self?.checkAuthorization()
        })
        present(ac, animated: true)
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    func checkAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.getNotificationSettings { [weak self] settings in
            
            if settings.authorizationStatus == .notDetermined {
                self?.notAuthorized()
            }
            
            if settings.authorizationStatus == .authorized {
                self?.scheduleLocal()
            }
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "This is a <Guess The Flag> game reminder"
        content.body = "You didn't enter the game in 24 hours, Don't you want to play, We miss you."
        content.categoryIdentifier = "alarm"
        content.sound = .default()
        
        let dayInSeconds: TimeInterval = 86400
        
        for day in 1...7 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: dayInSeconds * Double(day), repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func notAuthorized() {
        let ac = UIAlertController(title: "Not Authorized", message: "Please register first.\nGo to Settings -> Register", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    //
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        Button1.setImage(UIImage(named: countries[0]), for: .normal)
        Button2.setImage(UIImage(named: countries[1]), for: .normal)
        Button3.setImage(UIImage(named: countries[2]), for: .normal)
        //1
        title = "\(countries[correctAnswer].uppercased()), Your current score is \(score)"
        //
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        var title: String
        //P15 -> 3
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            sender.transform = .identity
        })
        //
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            //3
            title = "Wrong"
            let ac = UIAlertController(title: title, message: " That’s the flag of \(countries[sender.tag])\nCorrect answer is flag number \(correctAnswer + 1)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
            //
            score -= 1
        }
        //2
        questionsNumber += 1
        if questionsNumber == 10 {
            self.title = "Your final score is \(score)"
            //P12 -> 2
            if score > oldScore {
                let ac = UIAlertController(title: "Congrats", message: "You beat the old score\nNew score is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestion))
                oldScore = score
                saveScore()
                score = 0
                correctAnswer = 0
                questionsNumber = 0
                present(ac, animated: true)
            }
            //
            let ac = UIAlertController(title: "Game ended", message: "Game endedYour final score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            score = 0
            correctAnswer = 0
            questionsNumber = 0
            present(ac, animated: true)
        } else {
            askQuestion()
        }
        //
    }
    //P3 -> 3
    @objc func yourScore() {
        let ac = UIAlertController(title: "Current score", message: "Your current score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    //P12 -> 2
    func saveScore() {
        let defaults = UserDefaults.standard
        defaults.set(oldScore, forKey: "oldScore")
    }
}

