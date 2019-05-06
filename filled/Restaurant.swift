//
//  Restaurant.swift
//  kc673_p5
//
//  Created by kaishuo cheng on 4/14/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
enum Feature: CaseIterable{
    case Feature1, Feature2, Feature3, Feature4, Feature5, Feature6, Feature7
}
enum Type: CaseIterable{
    case FeatureA, FeatureB, FeatureC, FeatureD
}
class restaurant {
    var image: UIImage
    var name: String
    var feature1: Feature
    var type1: [Type]
    var cost: Int
    
    init(image: UIImage, name: String, feature1: Feature,type1: [Type],cost: Int) {
        self.image = image
        self.name = name
        self.feature1 = feature1
        self.type1 = type1
        self.cost = cost
    }
    
}
