//
//  ViewController.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController {

    var escena: Menu!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let vista = view as SKView
        
        escena = Menu(size: vista.bounds.size)
        escena.scaleMode = .AspectFill
        
        vista.presentScene(escena)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

