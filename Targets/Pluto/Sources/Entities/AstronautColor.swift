//
//  AstronautColor.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

enum AstronautColor {
    
    case one
    case two
    case none
    case combine
}

extension AstronautColor {
    
    var color: UIColor {
        switch self {
            
        case .one:
            return .green
        case .two:
            return .red
        case .none:
            return .white
        case .combine:
            return .yellow
        }
    }
    
    mutating func combine(_ new: AstronautColor) {
        switch self {
        case .one:
            switch new {
            case .one:
                self = .none
            case .two:
                self = .combine
            default:
                break
            }
        case .two:
            switch new {
            case .one:
                self = .combine
            case .two:
                self = .none
            default:
                break
            }
        case .none:
            switch new {
            case .one:
                self = .one
            case .two:
                self = .two
            default:
                break
            }
        case .combine:
            switch new {
            case .one:
                self = .two
            case .two:
                self = .one
            default:
                break
            }
        }
    }
    
}

