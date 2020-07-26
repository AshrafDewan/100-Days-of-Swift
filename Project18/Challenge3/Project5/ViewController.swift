//
//  ViewController.swift
//  Project5
//
//  Created by Ashraf on 12/29/19.
//  Copyright © 2019 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        //3
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        //
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        //P12 -> 3
        let defaults = UserDefaults.standard
        usedWords = defaults.object(forKey: "list") as? [String] ?? [String]()
        if usedWords.isEmpty {
            startGame()
        } else {
            title = defaults.object(forKey: "title") as? String ?? "Empty"
            usedWords = defaults.object(forKey: "list") as? [String] ?? [String]()
        }
        //
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        //P12 -> 3
        self.saveList()
        //
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self, ac] _ in
            guard let answer = ac.textFields?[0].text?.lowercased() else { return }
            self.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerCase = answer.lowercased()
        //2
        if lowerCase.isEmpty {
            showErrorMessage(myWord: lowerCase)
        } else if lowerCase.contains(" ") {
            showErrorMessage(myWord: lowerCase)
        } else if isPossible(word: lowerCase) {
            if isOriginal(word: lowerCase) {
                if isReal(word: lowerCase) {
                    
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    //P12 -> 3
                    self.saveList()
                    //
                    return
                } else {
                    showErrorMessage(myWord: lowerCase)
                }
            } else {
                showErrorMessage(myWord: lowerCase)
            }
        } else {
            showErrorMessage(myWord: lowerCase)
        }
        //
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        //1
        if word == tempWord {
            return false
            //
        } else {
            for letter in word {
                if let position = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: position)
                } else {
                    return false
                }
            }
            
            return true
        }
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        //1
        if range.length < 3 {
            return false
            //
        } else {
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
    }
    //2
    func showErrorMessage(myWord: String) {
        var myTitle = ""
        var myMessage = ""
        
        if myWord.isEmpty {
            myTitle = "No word inserted"
            myMessage = "You didn't enter any word, try to write something."
        } else if myWord.contains(" ") {
            myTitle = "An empty space entered"
            myMessage = "You entered empty space, this isn't allowed."
        } else if !isPossible(word: myWord) {
            myTitle = "Word not possible"
            myMessage = "You can't spell that word from \(title!.lowercased())."
        } else if !isOriginal(word: myWord) {
            myTitle = "Word already used"
            myMessage = "Be more original!"
        } else if !isReal(word: myWord) {
            myTitle = "Word not recognized"
            myMessage = "You can't just make thhem up, you know!"
    }
        
        let ac = UIAlertController(title: myTitle, message: myMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    //P12 -> 3
    func saveList() {
        let defaults = UserDefaults.standard
        defaults.set(title, forKey: "title")
        defaults.set(usedWords, forKey: "list")
    }
    //
}

