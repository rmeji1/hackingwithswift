//
//  GameScene.swift
//  project17
//
//  Created by robert on 2/28/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum ForceBomb{
  case never, always, random
}

enum SequenceType: CaseIterable {
  case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
  //MARK: PROPERTIES
  var gameScore: SKLabelNode!
  var score = 0 {
    didSet{
      gameScore.text = "Score: \(score)"
    }
  }
  var livesImage = [SKSpriteNode]()
  var lives = 3
  var activeSliceBG: SKShapeNode!
  var activeSliceFG: SKShapeNode!
  var activeSlicePoints = [CGPoint]()
  var isSwooshSoundActive = false
  var activeEnemies = [SKSpriteNode]()
  var bombSoundEffect: AVAudioPlayer!
  var popupTime = 0.9
  var sequence: [SequenceType]!
  var sequencePosition = 0
  var chainDelay = 3.0
  var nextSequenceQueued = true
  var gameEnded = false
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "sliceBackground")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    physicsWorld.gravity = CGVector(dx: 0, dy: -6) // vector arrow going straight down
    physicsWorld.speed = 0.85 // change gravity speed
    
    createScore()
    createLives()
    createSlices()
    
    sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
    
    for _ in 0 ... 1000 {
      let nextSequence = SequenceType.allCases.randomElement()!
      sequence.append(nextSequence)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
      self.tossEnemies()
    }
  }
  
  private func createScore() {
    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.position = CGPoint(x: 8, y:8)
    gameScore.text = "Score: 0"
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    addChild(gameScore)
  }
  
  private func createLives() {
    for k in 0..<3 {
      let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
      let x = CGFloat(834 + (k * 70))
      spriteNode.position = CGPoint(x: x, y: 720)
      addChild(spriteNode)
      livesImage.append(spriteNode)
    }
  }
  
  private func createSlices() {
    activeSliceBG = SKShapeNode()
    activeSliceBG.zPosition = 2
    
    activeSliceFG = SKShapeNode()
    activeSliceFG.zPosition = 2
    
    activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
    activeSliceBG.lineWidth = 9
    
    activeSliceFG.strokeColor = UIColor.white
    activeSliceFG.lineWidth = 5
    
    addChild(activeSliceBG)
    addChild(activeSliceFG)
  }
  
  private func playSwooshSound(){
    isSwooshSoundActive = true
    
    let randomNumber = Int.random(in: 1...3)
    let soundName = "swoosh\(randomNumber).caf"
    let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
    
    run(swooshSound){[unowned self] in
      self.isSwooshSoundActive = false
    }
  }
  
  private func redrawActiveSlice() {
    if activeSlicePoints.count < 2{
      activeSliceBG.path = nil
      activeSliceFG.path = nil
      return
    }
    
    while activeSlicePoints.count > 12 {
      activeSlicePoints.remove(at: 0)
    }
    
    let path = UIBezierPath()
    path.move(to: activeSlicePoints[0])
    
    for k in 1..<activeSlicePoints.count{
      path.addLine(to: activeSlicePoints[k])
    }
    
    activeSliceBG.path = path.cgPath
    activeSliceFG.path = path.cgPath
  }
  
  private func createEnemy(forceBomb: ForceBomb = .random){
    var enemy: SKSpriteNode
    var enemyType = Int.random(in: 0...6)
    
    switch forceBomb {
      case .never:
        enemyType = 1
      case .always:
        enemyType = 0
      default:
        break
    }
    
    if enemyType == 0{
      // bomb code goes here
      enemy = SKSpriteNode()
      enemy.zPosition = 1
      enemy.name = "bombContainer"
      
      let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
      bombImage.name = "bomb"
      enemy.addChild(bombImage)
      
      // 3
      if bombSoundEffect != nil {
        bombSoundEffect.stop()
        bombSoundEffect = nil
      }
      
      // 4
      let path = Bundle.main.path(forResource: "sliceBombFuse.caf", ofType:nil)!
      let url = URL(fileURLWithPath: path)
      let sound = try! AVAudioPlayer(contentsOf: url)
      bombSoundEffect = sound
      sound.play()
      
      // 5
      let emitter = SKEmitterNode(fileNamed: "sliceFuse")!
      emitter.position = CGPoint(x: 76, y: 64)
      enemy.addChild(emitter)
    }else{
      enemy = SKSpriteNode(imageNamed: "penguin")
      run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
      enemy.name = "enemy"
    }
    
    // position code goes here
    let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
    enemy.position = randomPosition
    
    let randomAngularVelocity = CGFloat.random(in: -6...6) / 2.0
    var randomXVelocity = 0
    
    if randomPosition.x < 256 {
      randomXVelocity = Int.random(in: 8...15)
    } else if randomPosition.x < 512 {
      randomXVelocity = Int.random(in: 3...5)
    } else if randomPosition.x < 768 {
      randomXVelocity = -Int.random(in: 3...5)
    } else {
      randomXVelocity = -Int.random(in: 8...15)
    }
    
    // 4
    let randomYVelocity = Int.random(in: 24...32)
    
    // 5
    enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
    enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
    enemy.physicsBody?.angularVelocity = randomAngularVelocity
    enemy.physicsBody?.collisionBitMask = 0
    
    addChild(enemy)
    activeEnemies.append(enemy)
    
  }
  
  private func tossEnemies() {
    popupTime *= 0.991
    chainDelay *= 0.99
    physicsWorld.speed *= 1.02
    
    let sequenceType = sequence[sequencePosition]
    
    switch sequenceType {
    case .oneNoBomb:
      createEnemy(forceBomb: .never)
      
    case .one:
      createEnemy()
      
    case .twoWithOneBomb:
      createEnemy(forceBomb: .never)
      createEnemy(forceBomb: .always)
      
    case .two:
      createEnemy()
      createEnemy()
      
    case .three:
      createEnemy()
      createEnemy()
      createEnemy()
      
    case .four:
      createEnemy()
      createEnemy()
      createEnemy()
      createEnemy()
      
    case .chain:
      createEnemy()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [unowned self] in self.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [unowned self] in self.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [unowned self] in self.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [unowned self] in self.createEnemy() }
      
    case .fastChain:
      createEnemy()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [unowned self] in self.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [unowned self] in self.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [unowned self] in self.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [unowned self] in self.createEnemy() }
    }
    
    sequencePosition += 1
    nextSequenceQueued = false
  }
  
  private func endGame(triggeredByBomb: Bool){
    if gameEnded {
      return
    }
    
    gameEnded = true
    physicsWorld.speed = 0
    isUserInteractionEnabled = false
    
    if bombSoundEffect != nil{
      bombSoundEffect.stop()
      bombSoundEffect = nil
    }
    
    if triggeredByBomb{
      livesImage.forEach { $0.texture = SKTexture(imageNamed: "sliceLifeGone") }
    }
  }
  
  private func subtractLife(){
    lives -= 1
    
    run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
    
    var life: SKSpriteNode
    
    if lives == 2{
      life = livesImage[0]
    }else if lives == 1 {
      life = livesImage[1]
    }else{
     life = livesImage[2]
      endGame(triggeredByBomb: false)
    }
    
    life.texture = SKTexture(imageNamed: "sliceLifeGone")
    life.xScale = 1.3
    life.yScale = 1.3
    life.run(SKAction.scale(to: 1, duration: 0.1))
  }
  override func update(_ currentTime: TimeInterval) {
    if activeEnemies.count > 0 {
      for node in activeEnemies {
        if node.position.y < -140 {
          node.removeAllActions()
          
          if node.name == "enemy"{
            node.name = ""
            subtractLife()
            node.removeFromParent()
            
            if let index = activeEnemies.index(of: node){
              activeEnemies.remove(at: index)
            }
          }else if node.name == "bombContainer"{
            node.name = ""
            node.removeFromParent()
            if let index = activeEnemies.index(of: node){
              activeEnemies.remove(at: index)
            }
          }
        }
      }
    } else {
      if !nextSequenceQueued {
        DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [unowned self] in
          self.tossEnemies()
        }
        
        nextSequenceQueued = true
      }
    }
    
    var bombCount = 0
    
    for node in activeEnemies {
      if node.name == "bombContainer" {
        bombCount += 1
        break
      }
    }
    
    if bombCount == 0 {
      // no bombs – stop the fuse sound!
      if bombSoundEffect != nil {
        bombSoundEffect.stop()
        bombSoundEffect = nil
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    activeSlicePoints.removeAll(keepingCapacity: true)
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    activeSlicePoints.append(location)
    redrawActiveSlice()
    
    activeSliceBG.removeAllActions()
    activeSliceFG.removeAllActions()
    
    activeSliceBG.alpha = 1.0
    activeSliceFG.alpha = 1.0
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    
    let location = touch.location(in: self)
    activeSlicePoints.append(location)
    redrawActiveSlice()
    
    if !isSwooshSoundActive{
      playSwooshSound()
    }
    
    let nodesAtPoint = nodes(at: location)
    
    for node in nodesAtPoint{
      if node.name == "enemy"{
        let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
        emitter.position = node.position
        addChild(emitter)
        
        node.name = ""
        node.physicsBody?.isDynamic = false
        
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeIn(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        
        let seq = SKAction.sequence([group,SKAction.removeFromParent()])
        node.run(seq)
        
        score += 1
        
        let index = activeEnemies.index(of: node as! SKSpriteNode)!
        activeEnemies.remove(at: index)
        
        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
      }else if node.name == "bomb"{
        // destroy bomb
        let emitter = SKEmitterNode(fileNamed: "sliceHitBomb")!
        emitter.position = node.position
        addChild(emitter)
        
        node.name = ""
        node.physicsBody?.isDynamic = false
        
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeIn(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        
        let seq = SKAction.sequence([group,SKAction.removeFromParent()])
        node.parent?.run(seq)
        
        let index = activeEnemies.index(of: node.parent as! SKSpriteNode)!
        activeEnemies.remove(at: index)
        
        run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
        endGame(triggeredByBomb: true)

      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
    activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesEnded(touches, with: event)
  }
}
