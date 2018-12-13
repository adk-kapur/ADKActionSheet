//
//  ActionData.swift
//  ADKActionSheet
//
//  Created by Work on 29/11/18.
//  Copyright © 2018 Work. All rights reserved.
//

import Foundation
import UIKit

public struct Action<T> {
    
    public fileprivate(set) var data: T?
    public fileprivate(set) var handler: ((Action<T>) -> Void)?
    
    public init(_ data: T?, handler: ((Action<T>) -> Void)?) {
        self.data = data
        self.handler = handler
    }
    
}

public struct ActionData {
    
    var title : String?
    var image : UIImage?
    
    init(title : String, image : UIImage) {
        
        self.title = title
        self.image = image
    }
}
