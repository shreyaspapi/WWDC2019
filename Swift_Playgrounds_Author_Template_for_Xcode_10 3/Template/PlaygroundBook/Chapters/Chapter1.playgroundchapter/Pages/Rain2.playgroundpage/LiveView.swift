//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit


let WorldCategory    : UInt32 = 0x1 << 1
let RainDropCategory : UInt32 = 0x1 << 2
let FloorCategory    : UInt32 = 0x1 << 3

class BackgroundNode : SKNode {
    
    public func setup(size : CGSize) {
        
        let yPos : CGFloat = size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0.3
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = RainDropCategory
        
        let skyNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: size))
        skyNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
        skyNode.strokeColor = SKColor.clear
        skyNode.zPosition = 0
        
        let groundSize = CGSize(width: size.width, height: size.height * 0.35)
        let groundNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: groundSize))
        groundNode.fillColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        groundNode.strokeColor = SKColor.clear
        groundNode.zPosition = 1
        
        addChild(skyNode)
        addChild(groundNode)
        
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
        
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
        
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
        
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        
        let xPosition =
            CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
        let yPosition = size.height + raindrop.size.height
        
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        
        addChild(raindrop)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
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


PlaygroundPage.current.liveView = ViewController()
