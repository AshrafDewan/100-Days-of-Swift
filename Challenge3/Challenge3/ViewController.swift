//
//  ViewController.swift
//  Challenge3
//
//  Created by Ashraf on 1/14/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var guessMe: UITextField!
    var wordToGuess: UITextField!
    var charsView: UIView!
    var charsButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var score = 7 {
        didSet {
            scoreLabel.text = "Life Points: \(score)"
        }
    }
    var randWord = ""
    var checkWord = ""
    var tempWord = ""
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
      
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.systemFont(ofSize: 36)
        scoreLabel.text = "Life Points: 7"
        view.addSubview(scoreLabel)
        
        guessMe = UITextField()
        guessMe.translatesAutoresizingMaskIntoConstraints = false
        guessMe.textAlignment = .center
        guessMe.font = UIFont.systemFont(ofSize: 36)
        guessMe.text = "GUESS THE WORD"
        guessMe.isUserInteractionEnabled = false
        guessMe.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(guessMe)
        
        wordToGuess = UITextField()
        wordToGuess.translatesAutoresizingMaskIntoConstraints = false
        wordToGuess.textAlignment = .center
        wordToGuess.placeholder = "LET'S PLAY A GAME"
        wordToGuess.font = UIFont.systemFont(ofSize: 44)
        wordToGuess.isUserInteractionEnabled = false
        view.addSubview(wordToGuess)
        
        charsView = UIView()
        charsView.translatesAutoresizingMaskIntoConstraints = false
        charsView.layer.borderColor = UIColor.gray.cgColor
        charsView.layer.borderWidth = 1
        view.addSubview(charsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            guessMe.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            guessMe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            wordToGuess.topAnchor.constraint(equalTo: guessMe.bottomAnchor, constant: 20),
            wordToGuess.bottomAnchor.constraint(equalTo: charsView.topAnchor, constant: -50),
            wordToGuess.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordToGuess.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            
            charsView.widthAnchor.constraint(equalToConstant: 1050),
            charsView.heightAnchor.constraint(equalToConstant: 400),
            charsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            charsView.topAnchor.constraint(equalTo: wordToGuess.bottomAnchor, constant: 20),
            charsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            ])
        
        let width = 150
        let height = 100
        
        for row in 0..<4 {
            for column in 0..<7 {
                let charButtons = UIButton(type: .system)
                charButtons.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                switch row {
                case 0 :
                    charButtons.setTitle(letters[0 + column], for: .normal)
                case 1 :
                    charButtons.setTitle(letters[7 + column], for: .normal)
                case 2 :
                    charButtons.setTitle(letters[14 + column], for: .normal)
                default:
                    if column <= 4 {
                        charButtons.setTitle(letters[21 + column], for: .normal)
                    } else {
                        return
                    }
                }
                
                charButtons.addTarget(self, action: #selector(charTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                
                charButtons.frame = frame
                charsView.addSubview(charButtons)
                charsButtons.append(charButtons)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSetup()
    }

    @objc func charTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        for _ in 1...randWord.count {
            if randWord.contains(buttonTitle) {
                if let position = randWord.firstIndex(of: Character(buttonTitle)) {
                    randWord.remove(at: position)
                    randWord.insert("?", at: position)
                    tempWord.remove(at: position)
                    tempWord.insert(Character(buttonTitle), at: position)
                    wordToGuess.text = tempWord
                }
            }
        }
        
        activatedButtons.append(sender)
        sender.isHidden = true
        score -= 1
        
        if score > 0 {
            if wordToGuess.text == checkWord {
                let ac = UIAlertController(title: "You won", message: "GOOD JOB", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.gameSetup()
                })
                present(ac, animated: true)
            }
        } else if score == 0 {
            if wordToGuess.text == checkWord {
                let ac = UIAlertController(title: "You won", message: "GOOD JOB", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.gameSetup()
                })
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "You lost", message: "GAME OVER", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.gameSetup()
                })
                present(ac, animated: true)
            }
        }
    }
    
    func gameSetup() {
        wordToGuess.text? = ""
        for btn in activatedButtons {
            btn.isHidden = false
        }
        activatedButtons.removeAll()
        score = 7
        
        if let gameFilePath = Bundle.main.path(forResource: "WordsList", ofType: "txt") {
            if let gameContent = try? String(contentsOfFile: gameFilePath) {
                let words = gameContent.components(separatedBy: "\n")
                randWord = words.randomElement()!
                checkWord = randWord
                for _ in 1...randWord.count {
                    wordToGuess.text? += "?"
                }
                tempWord = wordToGuess.text!
            }
        }
        guessMe.text = randWord
    }
}

