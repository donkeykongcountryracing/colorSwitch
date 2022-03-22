//
//  GameScene.swift
//  colorSwitch
//
//  Created by Ethan  Jin  on 25/9/2021.
//

import SpriteKit
import GameplayKit


struct physicsCategories{
    static let player: UInt32 = 1
    static let obstacles: UInt32 = 2
    static let treasure: UInt32 = 3
    static let colorSwitch: UInt32 = 4
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameSpriteWorld = SKNode()
    let player = SKShapeNode(circleOfRadius: 40)
    let cameraNode = SKCameraNode()
    var score = 0
    let scoreLabel = SKLabelNode()
    let scoreBox = SKSpriteNode()
    let pauseButton = SKSpriteNode()
    let playButton = SKSpriteNode()
    
    let restartButton = SKSpriteNode()
    let speedButton = SKSpriteNode()
    let normalButton = SKSpriteNode()
    let ground = SKSpriteNode()
    let pauseBack = SKSpriteNode()
    let texturePause = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = -22
        
        addChild(gameSpriteWorld)
        
        addPlayer(colour: .blue)
        addAllObstacles()
        treasureSequence()
        backgroundSequence()
        colorSwitchSequence()
        createPauseButton()
        createPlayButton()
        
        self.addChild(restartLabel)
        self.addChild(restartButton)
        
        self.addChild(cameraNode)
        camera/* node that determines which part of the scene's coordinate spaces are availibe to the view*/ = cameraNode
        cameraNode.position = player.position
        
        texturePause.size = CGSize(width: 800, height: 1200)
        pauseBack.size = CGSize(width: 800, height: 1200)
        self.addChild(texturePause)
        self.addChild(pauseBack)
        
        self.addChild(screen)
        
        //score labels
        scoreLabel.text = String(score)
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 75
        scoreLabel.fontColor = .black
        scoreBox.size = CGSize(width: 100, height: 90)
        scoreBox.texture = SKTexture(imageNamed: "button")
        scoreBox.position = CGPoint(x: 0,y: -600)
        scoreLabel.zPosition = 100
        scoreLabel.position.y = scoreBox.position.y-20
        self.addChild(scoreLabel)
        self.addChild(scoreBox)
        
        //ground
        ground.position = CGPoint(x: 0, y: -600)
        ground.size = CGSize(width: 1500, height: 10)
        ground.color = .clear
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
    }
        
    func addPlayer(colour: UIColor){
        player.fillColor = .blue
        player.strokeColor = .blue
        player.position = CGPoint(x: 0, y: -300)
        
        let playerBody = SKPhysicsBody(circleOfRadius: 15)
        playerBody.mass = 1.5
        playerBody.categoryBitMask = physicsCategories.player
        playerBody.collisionBitMask = 5
        playerBody.contactTestBitMask = physicsCategories.obstacles
        playerBody.contactTestBitMask = physicsCategories.treasure
        player.physicsBody = playerBody
        
        self.addChild(player)
    }
    
    func addCircle(pos: CGPoint){
        let circleObstacle = SKNode()
        let path = UIBezierPath() /*a path that consists of straight and curved line segments that you can render in your own custom view(defining a path of a shape/custom shape node)*/
        path.move(to: CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x: 0, y: -160))
        path.addArc(withCenter: CGPoint.zero/*location 0,0*/, radius: 160, startAngle: CGFloat(3.0*(Double.pi/2))/*perimeter/circumfurence*/, endAngle: CGFloat(0), clockwise: true)
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero, radius: 200, startAngle: CGFloat(0), endAngle: CGFloat(3.0*(Double.pi/2)), clockwise: false)
        
        for i in 0...3{
            let colors = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint.zero
            section.strokeColor = colors[i]
            section.fillColor = colors[i]
            section.zRotation = CGFloat(Double.pi/2.0) * CGFloat(i)
            circleObstacle.addChild(section)
            
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = physicsCategories.obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = physicsCategories.player
            sectionBody.affectedByGravity = false
            sectionBody.allowsRotation = false
            section.physicsBody = sectionBody
        }
        
        circleObstacle.position = pos
        self.addChild(circleObstacle)
        
        let rotateAction = SKAction.rotate(byAngle: 2.0 * CGFloat(Double.pi), duration: 10)
        circleObstacle.run(SKAction.repeatForever(rotateAction))
        
//        let section = SKShapeNode(path: path.cgPath)
//        section.position = CGPoint.zero
//        section.fillColor = .yellow
//        section.strokeColor = .yellow
//
//        self.addChild(section)
    }
    
    
    func addLine(pos: CGPoint){
        let path = UIBezierPath(roundedRect: CGRect(x: -400, y: pos.y, width: 200, height: 40), cornerRadius: 20)
//        let fullObstacle = SKSpriteNode()
        let obstacle = SKNode()
        
        for i in 1...8{
            let colors = [UIColor.blue,UIColor.red,UIColor.yellow,UIColor.blue,UIColor.purple,UIColor.red,UIColor.yellow,UIColor.blue,UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.strokeColor = colors[i]
            section.fillColor = colors[i]
            section.position.x += CGFloat(200*i)
            obstacle.addChild(section)
            
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = physicsCategories.obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = physicsCategories.player
            sectionBody.affectedByGravity = false
            sectionBody.allowsRotation = false
            section.physicsBody = sectionBody
        }
        
//        obstacle.position = pos
        self.addChild(obstacle)
//        let obstacleFull = SKSpriteNode()
//        for _ in 0...25{
//            let obstacleClone = obstacle
//            obstacleClone.position.x = CGFloat(x)
//            x += 800
//            obstacleFull.addChild(obstacleClone)
//        }
        let moveLeft = SKAction.moveBy(x: -1600, y: 0, duration: 10)
        let moveSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
            obstacle.run(moveSequence)
    }
    
    func startObstacle(pos: CGPoint){
//        var x = -400
//
//        for _ in 0...25{
//            addLine(pos: CGPoint(x: CGFloat(x), y: pos.y))
//            x += 800
//        }
        let create = SKAction.run {
            [unowned self] in
            self.addLine(pos: pos)
        }
        
        let wait = SKAction.wait(forDuration: 5) //why does it work for half the length
        let sequence = SKAction.sequence([create,wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        self.run(repeatForever)
       
    }
    
    func addSquare(pos: CGPoint) {
        let path = UIBezierPath(roundedRect: CGRect(x: -200, y: -200, width: 400, height: 40), cornerRadius: 20)
        
        let obstacle = SKNode()
        
        for i in 0...3{
            let colors = [UIColor.red,UIColor.yellow,UIColor.blue,UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.strokeColor = colors[i]
            section.fillColor = colors[i]
            section.zRotation = CGFloat(Double.pi/2.0) * CGFloat(i)//rotates one side/path by 90 degrees which makes it look like this path and the path in the before loop are connected and make a square
            obstacle.addChild(section)
            
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = physicsCategories.obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = physicsCategories.player
            sectionBody.affectedByGravity = false
            sectionBody.allowsRotation = false
            section.physicsBody = sectionBody
        }
        
        obstacle.position = pos
        self.addChild(obstacle)
        
        let rotateAction = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 10)
        obstacle.run(SKAction.repeatForever(rotateAction))
    
    }
    
    func addAllObstacles(){
        var circleY = 0
        var lineY = 800
        var squareY = 1600
        for _ in 1...12{
            addCircle(pos: CGPoint(x: 0, y: circleY))
            startObstacle(pos: CGPoint(x:0, y: lineY))
            addSquare(pos: CGPoint(x: 0, y: squareY))
            lineY += 2400
            circleY += 2400
            squareY += 2400
        }
        
    }
    
    func createTreasures(pos: CGPoint){
        let treasure = SKSpriteNode()
        
        let arrayOfTreasures = ["treasure","treasure","treasure","treasure","treasure","treasure","treasure","treasure","treasure","treasure","treasure","treasure","insta-win","insta-kill","insta-win","insta-kill"]
        let arrayOfTextureColor = [UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.red,UIColor.green,UIColor.blue,UIColor.yellow,UIColor.cyan]
        let randomText = Int.random(in: 0..<16)
       
        treasure.size = CGSize(width: 60, height: 60)
        treasure.position = pos
        treasure.color = arrayOfTextureColor[randomText]
        treasure.texture = SKTexture(imageNamed: arrayOfTreasures[randomText])
        
        let treasureBody = SKPhysicsBody(rectangleOf: treasure.size)
        treasureBody.affectedByGravity = false
        treasureBody.contactTestBitMask = physicsCategories.player
        treasureBody.collisionBitMask = 0
        treasureBody.categoryBitMask = physicsCategories.treasure
        treasure.physicsBody = treasureBody
        
        gameSpriteWorld.addChild(treasure)
    }
    
    func treasureSequence(){
        var y = 0
        for _ in 1 ... 21{
            createTreasures(pos: CGPoint(x: 0, y: y))
            y += 800
        }
    }
    
    func createPauseButton(){
        pauseButton.size = CGSize(width: 80, height: 80)
        pauseButton.position = CGPoint(x: -300, y: 510)
        pauseButton.color = .white
        pauseButton.zPosition = 101
        pauseButton.name = "pauseButton"
        let pauseTexture = SKTexture(imageNamed: "pause")
        pauseButton.texture = pauseTexture
        
        self.addChild(pauseButton)
    }
    
    func createPlayButton(){
        playButton.size = CGSize(width: 80, height: 80)
        playButton.position = CGPoint(x: -200, y: 510)
        playButton.color = .purple
        playButton.name = "playButton"
        playButton.zPosition = 102
        let playTexture = SKTexture(imageNamed: "play")
        playButton.texture = playTexture
        
        self.addChild(playButton)
    }

    let restartLabel = SKLabelNode()
    func createRestartButton(pos: CGPoint){
        restartLabel.text = "Restart"
        restartLabel.fontColor = .red
        restartLabel.fontName = "c"
        restartLabel.fontSize = 80
        restartLabel.zPosition = 104
        
        restartButton.name = "restartButton"
        restartButton.position = pos
        restartButton.color = .white
        restartButton.zPosition = 103
        restartButton.texture = SKTexture(imageNamed: "button")
        restartButton.size = CGSize(width: 300, height: 105)
        restartLabel.position.y = pos.y-20
        
    }
    
    func restartScene(){
        self.removeAllActions()
        self.removeAllChildren()
        self.scene?.removeFromParent()
        self.isPaused = true
        
        //What is super.viewDidLoad() and what does the code below really mean
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func addColorSwitch(pos: CGPoint){
        let colorSwitch = SKSpriteNode()
        
        colorSwitch.size = CGSize(width: 60, height: 60)
        colorSwitch.position = pos
        colorSwitch.texture = SKTexture(imageNamed: "colorswitch")
        
        colorSwitch.physicsBody = SKPhysicsBody(rectangleOf: colorSwitch.size)
        colorSwitch.physicsBody?.categoryBitMask = physicsCategories.colorSwitch
        colorSwitch.physicsBody?.affectedByGravity = false
        colorSwitch.physicsBody?.contactTestBitMask = physicsCategories.player
        colorSwitch.physicsBody?.collisionBitMask = 0
        
        self.addChild(colorSwitch)
    }
    
    func colorSwitchSequence(){
        var y = 500
        for _ in 1...20{
            addColorSwitch(pos: CGPoint(x: 0, y: y))
            y += 800
        }
    }
    
    func createVerticalScrollingBackground(pos: CGPoint){
        let background = SKSpriteNode()
        background.position = pos
        background.size = CGSize(width: 800, height: 1300)
        background.texture = SKTexture(imageNamed: "back")
        
        background.zPosition = -100
        self.addChild(background)
    }
    
    func backgroundSequence(){
        var y = -300
        for _ in 1...20{
            createVerticalScrollingBackground(pos: CGPoint(x: 0, y: y))
            y += 1299
        }
    }
    
    let screen = SKShapeNode(rectOf: CGSize(width: 800, height: 16800))
    
    func pauseScreen(){
        
        restartLabel.zPosition = 0
        restartButton.zPosition = 0
        
        restartButton.zPosition = 102
        pauseButton.zPosition = 102
        
        screen.fillColor = .white
        screen.alpha = 0.85
        screen.zPosition = 101
        
        self.isPaused = true
        physicsWorld.speed = 0 //rate at which physics in this scene is excecuted
        
        
    }
    
    func unpauseScreen(){
        
        restartLabel.zPosition = 104
        restartButton.zPosition = 103
        
        screen.alpha = 0
        self.isPaused = false
        physicsWorld.speed = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.velocity.dy = 800
        
        for touch in touches{
            let loc = touch.location(in: self)
            let touchedNode: SKNode = self.atPoint(loc)
            if let name = touchedNode.name {
                if name == "restartButton" {
                    restartScene()
                }
                if name == "pauseButton"{
                    pauseScreen()
                }
                if name == "playButton"{
                    unpauseScreen()
                }
            }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode{
            if nodeA.fillColor != nodeB.fillColor{
                player.physicsBody?.velocity = CGVector.zero
                self.isPaused = true
                scoreLabel.fontColor = .red
                scoreLabel.text = "You lose: " + String(score)
                scoreBox.size.width = 400
                createRestartButton(pos: player.position)
            }
            }
            
        let collisionColor = contact.bodyA.categoryBitMask == physicsCategories.colorSwitch ? contact.bodyB : contact.bodyA
        if collisionColor.categoryBitMask == physicsCategories.player{
            contact.bodyA.node?.removeFromParent()
            
            let array = [UIColor.red,UIColor.yellow,UIColor.blue,UIColor.purple]
            let i = Int.random(in: 0..<4)
            player.fillColor = array[i]
            player.strokeColor = array[i]
            
        }
        
        let collisionObject = contact.bodyA.categoryBitMask == physicsCategories.treasure ? contact.bodyB : contact.bodyA
            
            if collisionObject.categoryBitMask == physicsCategories.player{
                
                if let nodeC = contact.bodyA.node as? SKSpriteNode{
                    
                    if nodeC.color == UIColor.red {

                    contact.bodyA.node?.removeFromParent()
                    score += 1
                    scoreLabel.text = String(score)
                }
                    
                    
                    if nodeC.color == UIColor.green{
                            pauseBack.isHidden = false
                            texturePause.isHidden = false
                        
                        pauseBack.color = .black
                        pauseBack.alpha = 0.5
                        texturePause.texture = SKTexture(imageNamed: "insta-win label")
                        self.isPaused = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.pauseBack.isHidden = true
                            self.texturePause.isHidden = true
                            self.isPaused = true
                            self.scoreLabel.fontColor = .green
                            self.scoreLabel.text = "You Win"
                            self.scoreBox.size.width = 600
                            self.createRestartButton(pos: self.player.position)
                        
                    contact.bodyA.node?.removeFromParent()
                        }
                }
                    
                    
                    if nodeC.color == UIColor.blue {
                            pauseBack.isHidden = false
                            texturePause.isHidden = false

                        pauseBack.color = .black
                        pauseBack.alpha = 0.5
                        texturePause.color = .white
                        texturePause.texture = SKTexture(imageNamed: "insta-kill label")
                        self.isPaused = true


                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.pauseBack.isHidden = true
                        self.texturePause.isHidden = true
               
                    self.isPaused = true
                        self.scoreLabel.fontColor = .red
                        self.scoreLabel.text = "You Win"
                        self.scoreBox.size.width = 600
                        self.createRestartButton(pos: self.player.position)
                        contact.bodyA.node?.removeFromParent()
                        self.score += 1
                        self.scoreLabel.text = String(self.score)
                        }
                }
                    
                    if nodeC.color == UIColor.cyan {
                        pauseBack.isHidden = false
                        texturePause.isHidden = false

                    pauseBack.color = .black
                    pauseBack.alpha = 0.5
                    texturePause.color = .white
                    texturePause.texture = SKTexture(imageNamed: "bigger label")
                    self.isPaused = true
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.player.setScale(CGFloat(1.7))
                            self.player.physicsBody = SKPhysicsBody(circleOfRadius: 15*1.7)
                            
                            self.pauseBack.isHidden = true
                            self.texturePause.isHidden = true
                            contact.bodyA.node?.removeFromParent()
                            self.score += 1
                            self.scoreLabel.text = String(self.score)
                        }
                    }
                    
                    if nodeC.color == UIColor.yellow {
                        pauseBack.isHidden = false
                        texturePause.isHidden = false

                    pauseBack.color = .black
                    pauseBack.alpha = 0.5
                    texturePause.color = .white
                    texturePause.texture = SKTexture(imageNamed: "smaller label")
                    self.isPaused = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.player.setScale(CGFloat(0.3))
                            self.player.physicsBody = SKPhysicsBody(circleOfRadius: 15*0.3)
                            
                            self.pauseBack.isHidden = true
                            self.texturePause.isHidden = true
                            contact.bodyA.node?.removeFromParent()
                            self.score += 1
                            self.scoreLabel.text = String(self.score)
                        }
            }
                    
                    
                   
                        
//                        if nodeC.color == UIColor.brown {
//                            pauseBack.isHidden = false
//                            texturePause.isHidden = false
//
//                        pauseBack.color = .black
//                        pauseBack.alpha = 0.5
//                        texturePause.color = .white
//                        texturePause.texture = SKTexture(imageNamed: "faster label")
//                        self.isPaused = true
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//
//
//                                self.pauseBack.isHidden = true
//                                self.texturePause.isHidden = true
//                            }
//                        }
//
//
//                            if nodeC.color == UIColor.magenta {
//                                pauseBack.isHidden = false
//                                texturePause.isHidden = false
//
//                            pauseBack.color = .black
//                            pauseBack.alpha = 0.5
//                            texturePause.color = .white
//                            texturePause.texture = SKTexture(imageNamed: "slower label")
//                            self.isPaused = true
//
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//
//
//                                    self.pauseBack.isHidden = true
//                                    self.texturePause.isHidden = true
//                                }
//                    }
    }
            }
    }
    
    override func update(_ currentTime: TimeInterval) {
            
        let playerPositionInCamera = cameraNode.convert/*converts a point in this node coordinate system to the coordinate system of another node in the node tree*/(player.position, to: self)
        if playerPositionInCamera.y > -600 && !cameraNode/* exclamation mark checks if the player position is not equal to the camera node, exclamation means not equal to ____*/.hasActions() {
            cameraNode.position.y = player.position.y
        }
        
        if score == 12 {
                player.physicsBody?.velocity = CGVector.zero
                self.isPaused = true
                scoreLabel.fontColor = .green
                scoreLabel.text = "You Win"
                scoreBox.size.width = 600
                createRestartButton(pos: player.position)
        }

        if player.position.y > -300 {
            scoreLabel.position.y = player.position.y-420
            scoreBox.position.y = player.position.y-400
            pauseBack.position.y = player.position.y
            texturePause.position.y = player.position.y
            playButton.position.y = player.position.y+510
            pauseButton.position.y = player.position.y+510
        }
        else{
            playButton.position.y = 210
            pauseButton.position.y = 210
            scoreBox.position.y = -700
            scoreLabel.position.y = -720
        }
    }
    
}
            
