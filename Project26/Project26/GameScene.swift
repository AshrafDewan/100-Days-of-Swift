//
//  GameScene.swift
//  Project26
//
//  Created by Ashraf Dewan on 3/29/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import CoreMotion
import SpriteKit

enum collisionType: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    var isGameOver = false
    //2
    var levelLabel: SKLabelNode!
    var levelNumber = 1 {
        didSet {
            levelLabel.text = "Level: \(levelNumber)"
        }
    }
    //3
    var portalActive = true
    //
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 16, y: 732)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(levelNumber)", withExtension: "txt") else {
            fatalError("Couldn't find level1.txt in the app bundle.")
            
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Couldn't load level\(levelNumber).txt from the app bundle.")
        }
        let lines = levelString.components(separatedBy: "\n")
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: ((64 * column) + 32), y: ((64 * row) + 32))
                //1
                addNewElement(from: letter, in: position)
            }//
        }
    }
    //1
    func addNewElement(from letter: String.Element, in position: CGPoint) {
        if letter == "x" {
            addWall(to: position)
        } else if letter == "v" {
            addVortex(to: position)
        } else if letter == "s" {
            addStar(to: position)
        } else if letter == "f" {
            addFinish(to: position)
        } else if letter == "p" {
            addPortal(to: position)
        } else if letter == " " {
            
        } else {
            fatalError("Unknown level letter \(letter)")
        }
    }
    
    func addWall(to position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.name = "wall"
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = collisionType.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func addVortex(to position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = collisionType.vortex.rawValue
        node.physicsBody?.contactTestBitMask = collisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        addChild(node)
    }
    
    func addStar(to position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = collisionType.star.rawValue
        node.physicsBody?.contactTestBitMask = collisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func addFinish(to position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = collisionType.finish.rawValue
        node.physicsBody?.contactTestBitMask = collisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    //3
    func addPortal(to position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.name = "portal"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = collisionType.portal.rawValue
        node.physicsBody?.contactTestBitMask = collisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: -.pi, duration: 0.7)))
        addChild(node)
    }
    //
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = collisionType.player.rawValue
        player.physicsBody?.contactTestBitMask = collisionType.star.rawValue | collisionType.vortex.rawValue | collisionType.finish.rawValue | collisionType.portal.rawValue
        player.physicsBody?.collisionBitMask = collisionType.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelormeterData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelormeterData.accelerator.y * -50, dy: accelormeterData.accelerator.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        
        if bodyA == player {
            playerCollided(with: bodyB)
        } else if bodyB == player {
            playerCollided(with: bodyA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
            //2
        } else if node.name == "finish" {
            levelUp()
            //3
        } else if node.name == "portal" && portalActive == true {
            for portalNode in children {
                if portalNode.name == "portal" && portalNode != node {
                    player.physicsBody?.isDynamic = false
                    
                    let move = SKAction.move(to: portalNode.position, duration: 0.25)
                    let scale = SKAction.scale(to: 0.0001, duration: 0.25)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([move, scale, remove])
                    
                    player.run(sequence) { [weak self] in
                        self?.portalActive = false
                        self?.createPlayer()
                        self?.player.position = portalNode.position
                    }
                }
            }
        }
        portalActive = true
        //
    }
    //2
    func levelUp() {
        player.physicsBody?.isDynamic = false
        score = 0
        levelNumber += 1
        if levelNumber > 7 {
            levelNumber = 1
        }
        for node in children {
            if ["wall", "vortex", "star", "finish", "portal"].contains(node.name) {
                node.removeFromParent()
            }
        }
        player.removeFromParent()
        loadLevel()
        createPlayer()
        isGameOver = false
    }//
}
