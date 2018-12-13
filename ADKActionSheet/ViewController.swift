//
//  ViewController.swift
//  ADKActionSheet
//
//  Created by Work on 28/11/18.
//  Copyright © 2018 Work. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didtapbutton(_ sender: Any) {
        
        let actionController = ADKActionSheet()
        actionController.modalPresentationStyle = .overCurrentContext
        actionController.addAction(action: Action(ActionData(title: "Upload from Library", image: UIImage(named: "icon-galary")!), handler: { (action) in
            
            print("I am tapped")
        }))
        actionController.addAction(action: Action(ActionData(title: "Make in AR", image: UIImage(named: "icon-galary")!), handler: { (action) in
            
            print("I am tapped again")
        }))
//        actionController.addAction(action: ActionData(title: "Make in AR", image: UIImage(named: "icon-galary")!))
//        actionController.addAction(action: ActionData(title: "Use Template", image: UIImage(named: "icon-galary")!))
//        actionController.addAction(action: ActionData(title: "Meme with AI", image: UIImage(named: "icon-galary")!))
        present(actionController, animated: true, completion: nil)
    }
    
}

