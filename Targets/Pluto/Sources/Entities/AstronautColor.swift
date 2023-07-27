//
//  AstronautColor.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

enum AstronautColor: CaseIterable {
    
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
    
    mutating func combine(_ new: AstronautColor) -> AstronautColor {
        switch self {
        case .one:
            switch new {
            case .one:
                self = .none
                return .none
            case .two:
                self = .combine
                return .combine
            default:
                break
            }
        case .two:
            switch new {
            case .one:
                self = .combine
                return .combine
            case .two:
                self = .none
                return .none
            default:
                break
            }
        case .none:
            switch new {
            case .one:
                self = .one
                return .one
            case .two:
                self = .two
                return .two
            default:
                break
            }
        case .combine:
            switch new {
            case .one:
                self = .two
                return .two
            case .two:
                self = .one
                return .one
            default:
                break
            }
        }
        return .none
    }
    
    var categoryBitMask: UInt32 {
        switch self {
        case .one:
            return 4
        case .two:
            return 4
        case .none:
            return 4
        case .combine:
            return 4
        }
    }
    
    var imageName: String {
        switch self {
        case .one:
            return "GreenAstronaut"
        case .two:
            return "RedAstronuat"
        case .none:
            return "NoneAstronaut"
        case .combine:
            return "YellowAstronaut"
        }
    }
}

