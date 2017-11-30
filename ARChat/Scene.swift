//
//  Scene.swift
//  ARChat
//
//  Created by Andre Carrera on 11/30/17.
//  Copyright © 2017 Carrera. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    //TODO
    //make a label node in the view controller and edit it here
    
    //Right now it uses a UI textfield. 


    
    let textField = UITextField()

    
    @objc func enterTextField(textField: UITextField) {
        
        self.textField.removeFromSuperview()
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        //access to the view controller variables
        var currentViewController: ViewController?
        var upstreamResponder: UIResponder? = self.view
        var found = false
        
        while (found != true){
            upstreamResponder = upstreamResponder!.next
            if let viewController = upstreamResponder as? ViewController {
                currentViewController = viewController
                found = true
            }
            if upstreamResponder == nil {
                //could not find VC, PANIC!
                break
            }
        }
        //set the variable to the text in the textfield.
        currentViewController?.newtextField = textField.text!
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.5 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
        
        textField.text = ""
    }

    
    override func didMove(to view: SKView) {
        // Setup your scene here
        textField.frame = CGRect(x:0, y: ( view.bounds.height / 2) - 70, width:view.bounds.width, height: 100)
        
        
        //textField.borderStyle = UITextBorderStyle.roundedRect
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        textField.isOpaque = false
        textField.font = UIFont(name: "HelveticaNeue-Thin", size: 90)
        textField.textAlignment = .center
        
        
        
        textField.addTarget(self, action: #selector(Scene.enterTextField), for: UIControlEvents.editingDidEndOnExit)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.view?.addSubview(textField)
        textField.delegate = self as? UITextFieldDelegate
        self.focustf()
        
        
    }
    func focustf(){
        self.textField.becomeFirstResponder()
    }
}
