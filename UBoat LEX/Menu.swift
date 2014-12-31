//
//  Menu.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit

class Menu: SKScene {

    
    var fondo = SKSpriteNode()
    
    

    override func didMoveToView(view: SKView) {
        
        imagenPeriscopio()
        llamada()
        
    }
    
    
    func imagenPeriscopio() {
        
        fondo = SKSpriteNode(imageNamed: "periscopio")
        fondo.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        fondo.size = self.size
        addChild(fondo)
        
    }
    
    
    func llamada() {
     
        let label = SKLabelNode(fontNamed: "Avenir")
        
        label.text = "Jugar"
        label.fontColor = UIColor.blackColor()
        label.fontSize = 30
        
        
        label.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2)
        label.name = "Cambiar"
        addChild(label)
        

    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let tocarLabel: AnyObject = touches.anyObject()!
        
        let posicionTocar = tocarLabel.locationInNode(self)
        
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        
        if loQueTocamos.name == "Cambiar" {
            
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0)
            
            let  aparecerEscena = Juego(size: self.size)
            
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
            
        }
        
    }
    
    
    
    
    
    
    
    


}

