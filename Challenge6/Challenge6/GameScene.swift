//
//  GameScene.swift
//  Challenge6
//
//  Created by Ashraf Dewan on 7/26/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var backgroundImage: SKSpriteNode!
    var wall: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer?
    var countDownLabel: SKLabelNode!
    var countDown = 60 {
        didSet {
            countDownLabel.text = "\(countDown)s"
        }
    }
    
    var bullets: SKSpriteNode!
    var bulletsXPosition = 1000
    var emptyBulletsXPosition = 1000
    var bulletsCounter = 0
    var reloadLabel: SKLabelNode!
    
    var target: SKSpriteNode!
    var targets = ["target", "wrongTarget"]
    var targetTimer: Timer?
    
    let remove = SKAction.removeFromParent()
    
    var gameOver = false
    var gameOverLabel: SKLabelNode!
    var restartGameLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.name = "bg"
        backgroundImage.position = CGPoint(x: 512, y: 384)
        backgroundImage.zPosition = -2
        addChild(backgroundImage)
        
        createWalls()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontColor = .green
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 16, y: 700)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        countDownLabel = SKLabelNode(fontNamed: "Chalkduster")
        countDownLabel.fontColor = .cyan
        countDownLabel.text = "60s"
        countDownLabel.fontSize = 48
        countDownLabel.position = CGPoint(x: 512, y: 700)
        addChild(countDownLabel)
        
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.fontColor = .red
        reloadLabel.text = "RELOAD"
        reloadLabel.fontSize = 48
        reloadLabel.position = CGPoint(x: 700, y: 700)
        addChild(reloadLabel)
        
        createBullets()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countingDown), userInfo: nil, repeats: true)
        
        targetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
    }
    
    func createWalls() {
        wall = SKSpriteNode(imageNamed: "wall1")
        wall.position = CGPoint(x: 512, y: 125)
        wall.zPosition = -1
        addChild(wall)
        
        wall = SKSpriteNode(imageNamed: "wall2")
        wall.position = CGPoint(x: 512, y: 350)
        wall.zPosition = -1
        addChild(wall)
        
        wall = SKSpriteNode(imageNamed: "wall3")
        wall.position = CGPoint(x: 512, y: 525)
        wall.zPosition = -1
        addChild(wall)
    }
    
    func createBullets() {
        for _ in 0...5 {
            let bulletPosition = CGPoint(x: bulletsXPosition, y: 720)
            let currentBullets = nodes(at: bulletPosition)
            
            for bullet in currentBullets {
                if bullet.name != "bg" {
                    bullet.removeFromParent()
                }
            }
            
            bullets = SKSpriteNode(imageNamed: "loadedBullet")
            bullets.name = "bullet"
            bullets.position = CGPoint(x: bulletsXPosition, y: 720)
            addChild(bullets)
            bulletsXPosition -= 24
        }
        
        bulletsXPosition = 1000
        bulletsCounter = 0
    }
    
    func createEmptyBullets() {
        bulletsCounter += 1
        
        let bulletPosition = CGPoint(x: emptyBulletsXPosition, y: 720)
        let currentBullets = nodes(at: bulletPosition)
        
        for bullet in currentBullets {
            if bullet.name?.hasPrefix("wall") == false && bullet.name != "bg" {
                bullet.removeFromParent()
            }
        }
        
        bullets = SKSpriteNode(imageNamed: "emptyBullet")
        bullets.name = "bullet"
        bullets.position = bulletPosition
        addChild(bullets)
        
        emptyBulletsXPosition -= 24
        
        if emptyBulletsXPosition == 856 {
            emptyBulletsXPosition = 1000
        }
    }
    
    func reload() {
        bulletsXPosition = 1000
        emptyBulletsXPosition = 1000
        bulletsCounter = 0
        
        createBullets()
    }
    
    @objc func generateTarget() {
        guard let targetName = targets.randomElement() else { return }
        let random = Int.random(in: 0...2)
        
        switch random {
        case 0:
            target1(targetName)
            
        case 1:
            target2(targetName)
            
        default:
            target3(targetName)
        }
    }
    
    func target1(_ targetName: String) {
        target = SKSpriteNode(imageNamed: targetName)
        target.name = targetName + "1"
        target.position = CGPoint(x: -200, y: 125)
        target.xScale = 0.9
        target.yScale = 0.9
        addChild(target)
        let move = SKAction.move(to: CGPoint(x: 1224, y: 125), duration: 5)
        let sequence = SKAction.sequence([move, remove])
        target.run(sequence)
    }
    
    func target2(_ targetName: String) {
        target = SKSpriteNode(imageNamed: targetName)
        target.name = targetName + "2"
        target.position = CGPoint(x: -200, y: 350)
        target.xScale = 0.7
        target.yScale = 0.7
        addChild(target)
        let move = SKAction.move(to: CGPoint(x: 1224, y: 350), duration: 5)
        let sequence = SKAction.sequence([move, remove])
        target.run(sequence)
    }
    
    func target3(_ targetName: String) {
        target = SKSpriteNode(imageNamed: targetName)
        target.name = targetName + "3"
        target.position = CGPoint(x: -200, y: 525)
        target.xScale = 0.5
        target.yScale = 0.5
        addChild(target)
        let move = SKAction.move(to: CGPoint(x: 1224, y: 525), duration: 5)
        let sequence = SKAction.sequence([move, remove])
        target.run(sequence)
    }
    
    @objc func countingDown() {
        countDown -= 1
        
        if countDown <= 0 {
            countDownLabel.text = "0s"
            targetTimer?.invalidate()
            
            if countDown <= -5 {
                gameTimer?.invalidate()
                gameOverMessage()
                restartGameMessage()
            }
        }
    }
    
    func reloadMessage() {
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.fontColor = .red
        reloadLabel.text = "RELOAD"
        reloadLabel.fontSize = 48
        reloadLabel.position = CGPoint(x: 512, y: 378)
        reloadLabel.alpha = 0
        addChild(reloadLabel)
        
        let show = SKAction.fadeIn(withDuration: 0)
        let wait = SKAction.wait(forDuration: 0.5)
        let hide = SKAction.fadeOut(withDuration: 0.5)
        
        let sequence = SKAction.sequence([show, wait, hide])
        
        reloadLabel.run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if !gameOver {
            if bulletsCounter < 6 {
                createEmptyBullets()
                searchNodes(tappedNodes)
            } else {
                reloadMessage()
                bullet(tappedNodes)
            }
        } else {
            for node in tappedNodes {
                guard let tappedNode = node as? SKLabelNode else { return }
                guard tappedNode.text == ">>> RESTART GAME <<<" else { return }
                
                restartGame()
            }
        }
    }
    
    func bullet(_ tappedNodes: [SKNode]) {
        for node in tappedNodes {
            if node.name == "bullet" {
                reload()
            }
        }
    }
    
    func searchNodes(_ tappedNodes: [SKNode]) {
        for tappedNode in tappedNodes {
            guard let node = tappedNode as? SKSpriteNode else { return }
            
            if node.name?.hasPrefix("wrong") == true {
                score -= 200
                node.removeFromParent()
                
            } else if node.name?.hasPrefix("target") == true {
                
                if node.name?.hasSuffix("1") == true {
                    score += 100
                } else if node.name?.hasSuffix("2") == true {
                    score += 200
                } else if node.name?.hasSuffix("3") == true {
                    score += 300
                }
                
                node.removeFromParent()
            }
        }
    }
    
    func gameOverMessage() {
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = ">>> GAME OVER <<<"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .cyan
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameOverLabel)
        
        gameOver = true
        
    }
    
    func restartGameMessage() {
        restartGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartGameLabel.text = ">>> RESTART GAME <<<"
        restartGameLabel.fontSize = 48
        restartGameLabel.fontColor = .blue
        restartGameLabel.position = CGPoint(x: 512, y: 288)
        addChild(restartGameLabel)
        
        gameOver = true
    }
    
    func restartGame() {
        score = 0
        countDown = 60
        bulletsXPosition = 1000
        emptyBulletsXPosition = 1000
        bulletsCounter = 0
        gameOver = false
        
        gameOverLabel.removeFromParent()
        restartGameLabel.removeFromParent()
        
        createBullets()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countingDown), userInfo: nil, repeats: true)
        
        targetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
    }
}
