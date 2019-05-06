//
//  MyClass.swift
//  filled
//
//  Created by kaishuo cheng on 5/2/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class MyClass: NSObject {
    
    class myButton : UIButton {
        override var isHighlighted: Bool {
            didSet {
                if (isHighlighted) {
                    self.backgroundColor = UIColor.blue
                } else {
                    self.backgroundColor = UIColor.white
                }
            }
        }
    }
}
