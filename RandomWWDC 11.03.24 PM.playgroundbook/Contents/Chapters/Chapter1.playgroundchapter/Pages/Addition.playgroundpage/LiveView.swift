//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "additionBackground")
    
    let line = SKShapeNode()
    
    let label = SKLabelNode()
    
    let reload = SKSpriteNode()
    
    let reloadLabel = SKLabelNode()
    
    let firstNumber = Int.random(in: 1...49)
    
    let secondNumber = Int.random(in: 1...49)
    
    let ans = "?"
    
    let ansButton1 = SKSpriteNode(imageNamed: "btn1")
    let ansButton2 = SKSpriteNode(imageNamed: "btn2")
    let ansButton3 = SKSpriteNode(imageNamed: "btn3")
    let ansButton4 = SKSpriteNode(imageNamed: "btn4")
    
    let ansButton1L = SKLabelNode()
    let ansButton2L = SKLabelNode()
    let ansButton3L = SKLabelNode()
    let ansButton4L = SKLabelNode()
    
    var actualAnswer = 0
    
    override func didMove(to view: SKView) {
        
        actualAnswer = firstNumber + secondNumber
        
        let pathTodraw = CGMutablePath()
        pathTodraw.move(to: CGPoint(x: 0, y: frame.height * 0.70))
        pathTodraw.addLine(to: CGPoint(x: frame.width, y: frame.height * 0.70))
        line.lineWidth = 5
        line.path = pathTodraw
        line.strokeColor = .random()
        addChild(line)
        
        
        background.size = CGSize(width: frame.width, height: frame.height)
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.zPosition = -1
        self.addChild(background)
        
        
        label.position = CGPoint(x: frame.width / 2, y: frame.height * 0.92)
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 100
        label.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Addition"
        
        self.addChild(label)
        
        reload.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.93)
        reload.size = CGSize(width: 140, height: 140)
        reload.color = .random()
        reload.name = "reload"
        
        self.addChild(reload)
        
        reloadLabel.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.92)
        reloadLabel.fontName = "AvenirNext-Bold"
        reloadLabel.fontSize = 50
        reloadLabel.text = "↺"
        
        self.addChild(reloadLabel)
        
        makeButton(x: frame.width * 0.25, y: frame.height * 0.80)
        makeButton(x: frame.width * 0.36, y: frame.height * 0.80)
        makeButton(x: frame.width * 0.47, y: frame.height * 0.80)
        makeButton(x: frame.width * 0.61, y: frame.height * 0.80)
        makeButton(x: frame.width * 0.75, y: frame.height * 0.80)
        
        
        makeLabel(x: frame.width * 0.25, y: frame.height * 0.78, text: "\(firstNumber)")
        makeLabel(x: frame.width * 0.36, y: frame.height * 0.78, text: "+")
        makeLabel(x: frame.width * 0.47, y: frame.height * 0.78, text: "\(secondNumber)")
        makeLabel(x: frame.width * 0.61, y: frame.height * 0.78, text: "=")
        makeLabel(x: frame.width * 0.75, y: frame.height * 0.78, text: "\(ans)")
        
        ansButton1.position = CGPoint(x: frame.width * 0.32, y: frame.height * 0.59)
        ansButton1.size = CGSize(width: frame.width / 3.5, height: frame.height / 4)
        ansButton1.color = .random()
        ansButton1.name = "btn1"
        self.addChild(ansButton1)
        
        ansButton2.position = CGPoint(x: frame.width * 0.68, y: frame.height * 0.59)
        ansButton2.size = CGSize(width: frame.width / 3.5, height: frame.height / 4)
        ansButton2.color = .random()
        ansButton2.name = "btn2"
        
        self.addChild(ansButton2)
        
        ansButton3.position = CGPoint(x: frame.width * 0.32, y: frame.height * 0.30)
        ansButton3.size = CGSize(width: frame.width / 3.5, height: frame.height / 4)
        ansButton3.color = .random()
        ansButton3.name = "btn3"
        
        self.addChild(ansButton3)
        
        ansButton4.position = CGPoint(x: frame.width * 0.68, y: frame.height * 0.30)
        ansButton4.size = CGSize(width: frame.width / 3.5, height: frame.height / 4)
        ansButton4.color = .random()
        ansButton4.name = "btn4"
        
        self.addChild(ansButton4)
        
        ansButton1L.position = CGPoint(x: frame.width * 0.32, y: frame.height * 0.53)
        ansButton1L.fontName = "AvenirNext-Bold"
        ansButton1L.fontSize = 150
        self.addChild(ansButton1L)
        
        ansButton2L.position = CGPoint(x: frame.width * 0.68, y: frame.height * 0.53)
        ansButton2L.fontName = "AvenirNext-Bold"
        ansButton2L.fontSize = 150
        self.addChild(ansButton2L)
        
        ansButton3L.position = CGPoint(x: frame.width * 0.32, y: frame.height * 0.23)
        ansButton3L.fontName = "AvenirNext-Bold"
        ansButton3L.fontSize = 150
        self.addChild(ansButton3L)
        
        ansButton4L.position = CGPoint(x: frame.width * 0.68, y: frame.height * 0.23)
        ansButton4L.fontName = "AvenirNext-Bold"
        ansButton4L.fontSize = 150
        self.addChild(ansButton4L)
        
        var ansButtonAnswers = [firstNumber + secondNumber, Int.random(in: 1...99), Int.random(in: 1...99), Int.random(in: 1...99)].shuffled()
        
        ansButton1L.text = "\(ansButtonAnswers[0])"
        ansButtonAnswers.removeFirst()
        ansButton2L.text = "\(ansButtonAnswers[0])"
        ansButtonAnswers.removeFirst()
        ansButton3L.text = "\(ansButtonAnswers[0])"
        ansButtonAnswers.removeFirst()
        ansButton4L.text = "\(ansButtonAnswers[0])"
        ansButtonAnswers.removeFirst()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        
        if let name = touchedNode.name {
            if name == "btn1" {
                if ansButton1L.text == "\(actualAnswer)" {
                    label.text = "Success!!!"
                } else {
                    label.text = "Sorry!!!"
                }
            } else if name == "btn2" {
                if ansButton2L.text == "\(actualAnswer)" {
                    label.text = "Success!!!"
                } else {
                    label.text = "Sorry!!!"
                }
            } else if name == "btn3" {
                if ansButton3L.text == "\(actualAnswer)" {
                    label.text = "Success!!!"
                } else {
                    label.text = "Sorry!!!"
                }
            } else if name == "btn4" {
                if ansButton4L.text == "\(actualAnswer)" {
                    label.text = "Success!!!"
                } else {
                    label.text = "Sorry!!!"
                }
            } else if name == "reload" {
                PlaygroundPage.current.liveView = ViewController()
            }
            
            
        }
    }
    
    
    func makeLabel(x: CGFloat, y: CGFloat, text: String) {
        let label1 = SKLabelNode()
        label1.position = CGPoint(x: x, y: y)
        label1.fontName = "AvenirNext-Bold"
        label1.fontSize = 90
        label1.text = "\(text)"
        
        self.addChild(label1)
    }
    
    func makeButton(x: CGFloat, y: CGFloat){
        let button = SKSpriteNode()
        button.position = CGPoint(x: x, y: y)
        button.size = CGSize(width: 140, height: 140)
        button.color = .random()
        self.addChild(button)
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
