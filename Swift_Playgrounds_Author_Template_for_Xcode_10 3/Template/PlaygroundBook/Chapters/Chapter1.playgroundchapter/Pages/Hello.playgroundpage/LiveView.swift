//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    var helloArray = [""]
    
    let helloNode = SKLabelNode()
    
    let background = SKSpriteNode()
    
    
    
    override func didMove(to view: SKView) {
        
        
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        background.size = frame.size
        
        self.addChild(background)
        
        helloArray = ["","","","","","Hello","Bonjour", "Hola","Hallo","Ciao","OLÀ","Namaste","Salaam","ZDRAS-TVUY-TE","Ohayo","AHN-YOUNG-HA-SE-YO","Merhaba","Sain Bainuu","Salemetsiz Be","Szia","Marhaba","Sannu","Jambo","Ni Hau","Nay Hoh","Halo"]
        
        helloNode.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        helloNode.fontSize = 100
        helloNode.fontName = "Helvetica Neue"
        helloNode.text = "Hello"
        helloNode.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        helloNode.zPosition = 100
        
        self.addChild(helloNode)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        sleep(2)
        helloNode.text = helloArray[0]
        helloArray.removeFirst()
        
    }
    
}

class ViewController : UIViewController {
    
    override func loadView() {
        
        let view = SKView(frame: CGRect(x:0 , y:0, width: 1536, height: 2048))
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        self.view = view
        
    }
    
}

PlaygroundPage.current.liveView = ViewController()
