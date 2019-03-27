
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

//: A SpriteKit based Playground

import Foundation
import PlaygroundSupport
import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
        
    let scoreLabel = SKLabelNode()
    
    let levelLabel = SKLabelNode()
    
    let wait = SKAction.wait(forDuration: 0.7)
    
    let levelUpSound = SKAction.playSoundFileNamed("lvlup.wav", waitForCompletion: false)
    let backgroundSound = SKAudioNode(fileNamed: "bkg.wav")
    let explosionSound = SKAction.playSoundFileNamed("exp.wav", waitForCompletion: false)
    
    let tapToStartLabel = SKLabelNode()
    let tapToRestartLabel = SKLabelNode()
    
    
    
    var levelNumber = 0 {
        didSet {
            levelLabel.text = "Level: \(levelNumber)"
            levelAnimation()
            
        }
    }
    
    var gameScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(gameScore)"
        }
    }
    
    
    enum gameState{
        case preGame // when the game state in before the game starts
        case inGame  // when the game state is during the game
        case afterGame // when the game state is after the game ends
    }
    
    
    var currentGameState = gameState.preGame
    
    
    
    let background = SKSpriteNode(imageNamed: "background.png")
    
    let player = SKSpriteNode(imageNamed: "playerShip.png")
    
    
    struct PhysicsCategories {
        static let None   : UInt32 = 0
        static let Player : UInt32 = 0b1  //1
        static let Enemy  : UInt32 = 0b10 //2
        
    }
    
    func levelAnimation(){
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([levelUpSound, scaleUp, scaleDown])
        levelLabel.run(scaleSequence)
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
            
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height * CGFloat(i))
            background.name = "Background"
            background.zPosition = 0
            self.addChild(background)
            
        }
        
        
        player.setScale(0.5)
        player.position = CGPoint(x: self.size.width / 2, y: -self.size.height)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 20
        self.addChild(scoreLabel)
        
        levelLabel.text = "Level: 0"
        levelLabel.fontSize = 70
        levelLabel.fontColor = SKColor.white
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        levelLabel.position = CGPoint(x: self.size.width * 0.85, y: self.size.height + levelLabel.frame.size.height)
        levelLabel.zPosition = 20
        self.addChild(levelLabel)
        
        tapToStartLabel.text = "Tap!!!"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        let moveOnToScreen = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreen)
        levelLabel.run(moveOnToScreen)
        
        self.addChild(backgroundSound)
    }
    
    func addScore(){
        gameScore += 1
        
        if gameScore == 5 || gameScore == 10 || gameScore == 20 {
            startNewLevel()
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let body1 = contact.bodyA
        let body2 = contact.bodyB
        
        spawnExplosion(spawnPosition: body1.node!.position)
        spawnExplosion(spawnPosition: body2.node!.position)
        
        body1.node?.removeFromParent()
        body2.node?.removeFromParent()
        
        runGameOver()
        
    }
    
    @objc var lastUpdateTime: TimeInterval = 0
    @objc var deltaFrameTime: TimeInterval = 0
    @objc var amountToMovePerSecond: CGFloat = 600.0 //play with it to move the background slow and fast
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            
            background, stop in
            
            background.position.y -= amountToMoveBackground
            
            
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
            
        }
        
    }
    
    
    func spawnExplosion(spawnPosition: CGPoint) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion.png")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
        
    }
    
    
    
    
    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip.png")
        enemy.setScale(0.5)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy)
        
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        addScore()
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
    }
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1
        case 2: levelDuration = 0.5
        case 3: levelDuration = 0.3
        case 4: levelDuration = 0.1
        case 5: levelDuration = 0.1
        default: levelDuration = 0.2
        print("Cannot find level information")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let mytransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: mytransition)
        
        
        
    }
    
    
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
            
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
        
        
        
    }
    
    
    func endGame(){
        self.removeAllChildren()
        
        tapToRestartLabel.text = "The End"
        tapToRestartLabel.fontSize = 100
        tapToRestartLabel.fontColor = SKColor.white
        tapToRestartLabel.zPosition = 1
        tapToRestartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tapToRestartLabel.alpha = 0
        self.addChild(tapToRestartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToRestartLabel.run(fadeInAction)
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        self.addChild(background)
        
    }
    
    func startGame(){
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnScreen = SKAction.moveTo(y: self.size.height * 0.3, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnScreen, startLevelAction])
        player.run(startGameSequence)
        
    }
    
    
    //moving finger in the scene
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
            
            if player.position.x > gameArea.maxX - player.size.width / 2{
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            
            if player.position.x < gameArea.minX + player.size.width / 2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
            
            
        }
    }
    
}

class ViewController : UIViewController {
    
    override func loadView() {
        
        let view = SKView(frame: CGRect(x:0 , y:0, width: 1536, height: 2048))
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        //
        //// Present the scene
        view.presentScene(scene)
        self.view = view
        
    }
    
}

class GameOverScene: SKScene{
    
    @objc let restartLabel = SKLabelNode(fontNamed: "theBoldFont")
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "theBoldFont")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 95
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
            }
            
            
        }
        
    }
    
    
    
    
    
    
    
}

// Instantiate a new instance of the live view from the book's auxiliary sources and pass it to PlaygroundSupport.
PlaygroundPage.current.liveView = ViewController()

