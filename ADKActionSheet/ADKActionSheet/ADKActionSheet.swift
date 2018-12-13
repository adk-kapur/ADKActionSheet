//
//  ADKActionSheet.swift
//  ADKActionSheet
///Users/Work/Documents/custom action sheet/ADKActionSheet/ADKActionSheet/ViewController.swift
//  Created by Work on 28/11/18.
//  Copyright © 2018 Work. All rights reserved.
//

import Foundation
import UIKit

open class ADKActionSheet : ADKActionController {
    
    fileprivate lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // COMMENT : uncomment to hide all background
       // backgroundView.addSubview(blurView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blurView.frame = backgroundView.bounds
    }
    
    
}
