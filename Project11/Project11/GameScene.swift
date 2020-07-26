//
//  GameScene.swift
//  Project11
//
//  Created by Ashraf on 1/19/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    //3
    var boxCounter = 0
    var counterLabel: SKLabelNode!

    var ballCounter: Int = 5 {
        didSet {
            counterLabel.text = "Balls: \(ballCounter)"
        }
    }
    
    let boxSize = CGSize(width: Int.random(in: 16...128), height: 16)
    var box: SKSpriteNode!
    var boxes = [SKNode]()
    //
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        //3
        counterLabel = SKLabelNode(fontNamed: "chalkduster")
        counterLabel.text = "Balls: 5"
        counterLabel.horizontalAlignmentMode = .right
        counterLabel.position = CGPoint(x: 980, y: 650)
        addChild(counterLabel)
        //
        editLabel = SKLabelNode(fontNamed: "chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: boxSize)
                box.name = "Obstacle"
                box.zRotation = CGFloat.random(in: 1...3)
                box.position = location
                box.physicsBody = SKPhysicsBody.init(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
                //3
                boxes.append(box)
                boxCounter += 1
                //
            } else {
                //1
                let allBalls = [SKSpriteNode(imageNamed: "ballBlue"), SKSpriteNode(imageNamed: "ballCyan"), SKSpriteNode(imageNamed: "ballGreen"), SKSpriteNode(imageNamed: "ballGrey"), SKSpriteNode(imageNamed: "ballPurple"), SKSpriteNode(imageNamed: "ballRed"), SKSpriteNode(imageNamed: "ballYellow")]
                let ball = allBalls.randomElement()!
                //
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.name = "ball"
                //2
                ball.position = CGPoint(x: location.x, y: CGFloat.random(in: 640...768))
                //3
                if boxes.isEmpty {
                    return
                } else {
                    if ballCounter <= 0 {
                        ballCounter = 0
                        ball.removeFromParent()
                    } else {
                        ballCounter -= 1
                        addChild(ball)
                    }
                }
                //
            }
        }
    }

    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        //3
        if object.name == "Obstacle" {
            terminate(box: object)
            boxCounter -= 1
        } else if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballCounter += 1
            gameEnded()
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            gameEnded()
        }
        //
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    //3
    func terminate(box: SKNode) {
        boxes.remove(at: boxes.firstIndex(of: box)!)
        box.removeFromParent()
    }
    
    func gameEnded() {
        if ballCounter <= 0 || boxCounter == 0 {
            if boxCounter == 0 {
                if score > 0 {
                    let ac = UIAlertController(title: "You won", message: "Congratulations, you removed all obstacles\nYour current score is \(score)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                        self?.restartGame()
                    })
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.view?.window?.rootViewController?.present(ac, animated: true)
                } else {
                    let ac = UIAlertController(title: "You lost", message: "Sorry, you removed all obstacles but your current score is \(score)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                        self?.restartGame()
                    })
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.view?.window?.rootViewController?.present(ac, animated: true)
                }
            } else {
                let ac = UIAlertController(title: "You lost", message: "Sorry, you couldn't remove all obstacles", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                    self?.restartGame()
                })
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.view?.window?.rootViewController?.present(ac, animated: true)
            }
        }
    }
    
    func restartGame() {
        score = 0
        boxCounter = 0
        ballCounter = 5
        editingMode = false
        for box in boxes {
            box.removeFromParent()
            boxes.remove(at: boxes.firstIndex(of: box)!)
        }
    }
    //
}
