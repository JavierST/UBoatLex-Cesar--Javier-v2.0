//
//  Juego.swift
//  UBoat LEX
//

//  INCLUYE DETECCION DE COLISION TORPEDO-ENEMIGO Y TAMBIEN SUBMARINO-ENEMIGO DESCONTANDO EL NUMERO DE SUBMARINOS CUANDO OCURRE ESTO ULTIMO


//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit


class Juego: SKScene, SKPhysicsContactDelegate {

    var submarino = SKSpriteNode()
    var prisma = SKSpriteNode()
    var torpedo = SKSpriteNode()
    var malo = SKSpriteNode()
    
    var moverArriba = SKAction()
    var moverAbajo = SKAction()
    var puntos = 0
    var puntuacion = SKLabelNode()
    var numeroSubmarinos = 3
    var muestraNumSubmarinos = SKLabelNode()
    let velocidadFondo: CGFloat = 2

    
    
    // Defino los diferentes tipos de valores para despues poder detectar colisiones entre objetos
    
    enum tipoObjeto:UInt32 {
        
        case heroe = 1
        case torpedo = 2
        case enemigo = 4
    }
    
    
    
    override     func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.cyanColor()
        view.showsPhysics = false
        heroe()
        prismaticos()
        crearEscenario()
        enemigo()
        target()
        marcador()
        
    }

// Llamada cuando torpedo hace contacto con enemigo, para posteriormente llamar a destruyeEnemigo, pero tambien cuando enemigo contacta con el submarino, tras lo cual llama a destruyeSubmarino
    
    func didBeginContact(contact: SKPhysicsContact!) {
        
        
        // En caso de producirse contacto entre dos objetos...
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        // Si uno es el torpedo y el otro el enemigo, llama al metodo destruyeEnemigo
        case tipoObjeto.torpedo.rawValue | tipoObjeto.enemigo.rawValue:
            self.destruyeEnemigo(contact.bodyB.node as SKSpriteNode!, malo:contact.bodyA.node as SKSpriteNode!)
            
        // Si uno es el submarino y el otro el enemigo, llama al metodo destruyeSubmarino
        case tipoObjeto.heroe.rawValue | tipoObjeto.enemigo.rawValue:
            self.destruyeSubmarino(contact.bodyB.node as SKSpriteNode!, malo:contact.bodyA.node as SKSpriteNode!)
            
        default:
            return
            
        }
    }

    
    
    override    func update(currentTime: NSTimeInterval) {
        scrollHorizontal()
       
    }

        func enemigo(){
        let malo = SKSpriteNode(imageNamed: "enemigo")
        
        // Genera la posicion aleatoria en el eje vertical en que se presentará el enemigo
        var aleat = (arc4random_uniform(UInt32(frame.height)))

            malo.position.y = CGFloat(aleat)

        // La proxima linea la habilito para poder comprobar que el submarino choca con el enemigo en las posiciones altas de la pantalla, y a la vez inhibo la liena del " malo.position.x = frame.width-50"
        // malo.position.x = 400
        // La proxima linea la utilizo para el juego en modo normal
        malo.position.x = frame.width-50
       
        malo.zPosition = 5
        malo.name = "enemigo"
        malo.setScale(0.6-malo.position.y/1000)
        malo.physicsBody = SKPhysicsBody (rectangleOfSize:malo.size)
        malo.physicsBody?.affectedByGravity = false
        malo.physicsBody?.dynamic = true
        //Selecciona la categoria del enemigo, y se tendrán en cuenta las colisiones entre éste y torpedo o bien éste y submarino
        malo.physicsBody?.categoryBitMask = tipoObjeto.enemigo.rawValue
        malo.physicsBody?.collisionBitMask = tipoObjeto.torpedo.rawValue | tipoObjeto.heroe.rawValue
        malo.physicsBody?.contactTestBitMask = tipoObjeto.heroe.rawValue | tipoObjeto.torpedo.rawValue
        
        self.addChild(malo)
    }
        func marcador (){
            puntuacion.fontName = "arial"
            puntuacion.text = "Puntuacion : \(puntos)"
            puntuacion.fontSize = 10
            puntuacion.position = CGPoint(x: size.width / 2-40, y: size.height / 2 - 150)
            addChild(puntuacion)
            
            muestraNumSubmarinos.fontName = "arial"
            muestraNumSubmarinos.text = "Submarinos: \(numeroSubmarinos) "
            muestraNumSubmarinos.fontSize = 10
            muestraNumSubmarinos.position = CGPoint(x: size.width / 2 + 40, y: size.height / 2 - 150)
            addChild(muestraNumSubmarinos)
    }
    
    func actualizaMarcador(){
            puntuacion.text = "Puntuacion : \(puntos)"
            muestraNumSubmarinos.text = "Submarinos : \(numeroSubmarinos)"
    }
    
    func target(){
        let tiro = SKSpriteNode(imageNamed: "Tiro")
        tiro.setScale(0.1)
        tiro.position = CGPoint(x: size.width / 2 + 290, y: size.height / 2 - 150)
        tiro.zPosition = 5
        tiro.name = "TiroBlanco"
        addChild(tiro)
    }
    
    
        // Crea el submarino
    func heroe() {
        
        submarino = SKSpriteNode(imageNamed: "UBoat")
        submarino.zPosition = 1
        submarino.position = CGPointMake(100, 200)
        submarino.setScale(0.5-submarino.position.y/1000)
        submarino.name = "heroe"
        submarino.physicsBody = SKPhysicsBody (rectangleOfSize:submarino.size)
        submarino.physicsBody?.dynamic = true
        
        //Selecciona la categoria del submarino, y se tendrán en cuenta las colisiones entre éste y el enemigo
        
        submarino.physicsBody?.categoryBitMask = tipoObjeto.heroe.rawValue
        submarino.physicsBody?.collisionBitMask = tipoObjeto.enemigo.rawValue
        submarino.physicsBody?.contactTestBitMask = tipoObjeto.enemigo.rawValue
        submarino.physicsBody?.affectedByGravity = false

        moverArriba = SKAction.moveByX(30, y: 20, duration: 0.2)
        moverAbajo = SKAction.moveByX(-30, y: -20, duration: 0.2)
        addChild(submarino)
    }
    
        // Crea el lanzamiento del torpedo
    func disparoTorpedo() {
        
        torpedo = SKSpriteNode(imageNamed: "torpedo")
        torpedo.xScale = 20
        torpedo.yScale = 1
        torpedo.setScale(0.05)
        torpedo.zPosition = 2
        // Posicion inicial de lanzamiento del torpedo en funcion de la posicion del submarino
        torpedo.position = CGPointMake(submarino.position.x+60,submarino.position.y-20)
        
        torpedo.physicsBody = SKPhysicsBody (rectangleOfSize:torpedo.size)
        torpedo.physicsBody?.affectedByGravity = false
        torpedo.physicsBody?.dynamic = true
        
        //Selecciona la categoria del torpedo, y se tendrán en cuenta las colisiones entre éste y el enemigo
        
        torpedo.physicsBody?.categoryBitMask = tipoObjeto.torpedo.rawValue
        torpedo.physicsBody?.collisionBitMask = tipoObjeto.enemigo.rawValue
        torpedo.physicsBody?.contactTestBitMask = tipoObjeto.enemigo.rawValue
        
        // Lanza el torpedo en horizontal hasta qeu salga de la pantalla (con 50 puntos de más)
        var torpedoMovim = SKAction.moveByX(frame.width+50, y: 0, duration: 1.5)
        addChild(torpedo)
        
        torpedo.runAction(torpedoMovim)
       
        //Cuando el torpedo llega al final de su recorrido (ancho de pantalla + 50 puntos) es eliminado de memoria
        if torpedo.position.x == frame.width+50 {
         torpedo.removeFromParent()
        }
    }
    
    
    func destruyeSubmarino(submarino: SKSpriteNode, malo: SKSpriteNode) {
        
        // Cuando el submarino colisiona con el enemigo, se eliminan los dos, descuenta un submarino del total y suma un 
        // punto, actualiza el marcador y aparecen de nuevo un enemigo y un submarino
        submarino.removeFromParent()
        malo.removeFromParent()
        numeroSubmarinos-=1
        puntos+=1
        actualizaMarcador()
        heroe()
        enemigo()
    }
    
    
    func destruyeEnemigo(torpedo: SKSpriteNode, malo: SKSpriteNode) {
        // Cuando el torpedo colisiona con el enemigo, se eliminan los dos, suma un
        // punto, actualiza el marcador y aparecen de nuevo un enemigo
        torpedo.removeFromParent()
        malo.removeFromParent()
        puntos+=1
        actualizaMarcador()
        enemigo()
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for toke: AnyObject in touches {
            
            let dondeTocamos = toke.locationInNode(self)
            let loQueTocamos = self.nodeAtPoint(dondeTocamos)
            
            // la escala del subamrino varia en funcion de su altura en la pantalla para dar efecto de lejania
            submarino.setScale(0.5-submarino.position.y/1000)
            
            if loQueTocamos.name == "TiroBlanco" {
                 disparoTorpedo()
            }else{
                if dondeTocamos.y > submarino.position.y {
                    if submarino.position.y < frame.width {
                        submarino.runAction(moverArriba)
                    }
                } else {
                    if submarino.position.y > 50 {
                        submarino.runAction(moverAbajo)
                    }
                }
            }
            
        }
    }
    
    func prismaticos() {
        
        prisma = SKSpriteNode(imageNamed: "prismatic")
        prisma.setScale(0.66)
        prisma.zPosition = 2
        prisma.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        addChild(prisma)
    }
    
    func crearEscenario() {
        for var indice = 0; indice < 2; ++indice {
            
            let fondo = SKSpriteNode(imageNamed: "mar4")
            fondo.position = CGPoint(x: indice * Int(fondo.size.width), y: 0)
            
            fondo.name = "fondo"
            fondo.zPosition = 0
            
            addChild(fondo)

        }
    }
    
    func scrollHorizontal() {
        
        self.enumerateChildNodesWithName("fondo", usingBlock: { (nodo, stop) -> Void in
            if let fondo = nodo as? SKSpriteNode {
                
                fondo.position = CGPoint(
                    x: fondo.position.x - self.velocidadFondo,
                    y: fondo.position.y)
                
                if fondo.position.x <= -fondo.size.width {
                    
                    fondo.position = CGPointMake(
                        fondo.position.x + fondo.size.width * 2,
                        fondo.position.y)
                }
            }
        })
        
    }
    
}

    




