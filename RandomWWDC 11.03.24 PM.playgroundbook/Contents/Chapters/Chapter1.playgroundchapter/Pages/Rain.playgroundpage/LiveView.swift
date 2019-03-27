
//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit


class BackgroundNode : SKNode {
    
    public func setup(size : CGSize) {
        let yPos : CGFloat = size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0.3
    }
}

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    
    //Change for more raindrops
    private var rainDropSpawnRate : TimeInterval = 0.5
    
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    let backgroundNode = BackgroundNode()
    
    override func sceneDidLoad(){
        self.lastUpdateTime = 0
        backgroundNode.setup(size: self.size)
        addChild(backgroundNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        currentRainDropSpawnTime += dt
        
        // Update the spawn timer
        currentRainDropSpawnTime += dt
        
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }
        
        
        self.lastUpdateTime = currentTime
    }
    
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        let xPosition =
            CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
        let yPosition = size.height + raindrop.size.height
        
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        
        addChild(raindrop)
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


PlaygroundPage.current.liveView = ViewController()
