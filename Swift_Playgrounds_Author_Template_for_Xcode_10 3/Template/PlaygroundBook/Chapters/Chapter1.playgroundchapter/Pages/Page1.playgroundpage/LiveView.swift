
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
    
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    let backgroundNode = BackgroundNode()
    
    override func sceneDidLoad(){
        backgroundNode.setup(size: self.size)
        addChild(backgroundNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spawnRaindrop()
    }
    
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
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


