//
//  GameAlertType.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

enum GameAlertType {
    case success
    case fail
    case pause
    case tutorial(activate: [TutorailView.Activate], bottomString: String, topString: String)
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        case .pause:
            return UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 0.75)
        case .fail:
            return UIColor(red: 0, green: 0.044, blue: 0.242, alpha: 0.85)
        default:
            return .clear
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .success:
            return UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1)
        case .fail, .pause:
            return .white
        default:
            return .clear
        }
    }
    
    var title: String {
        switch self {
        case .success:
            return "Nice Flight!"
        case .fail:
            return "oh..no"
        case .pause:
            return "paused"
        default:
            return ""
        }
    }
    
    var upButtonTitle: String {
        switch self {
        case .success:
            return "next stage"
        case .fail:
            return "try again"
        case .pause:
            return "resume"
        default:
            return ""
        }
    }
    
    var downButtonTitle: String {
        switch self {
        case .success, .fail:
            return "return to main"
        case .pause:
            return "end game"
        default:
            return ""
        }
    }
    
    var upButtonIcon: UIImage {
        switch self {
        case .success:
            return UIImage(systemName: "arrow.right")!
        case .fail:
            return UIImage(systemName: "arrow.counterclockwise")!
        case .pause, .tutorial:
            return UIImage()
            
        }
    }
    
    var titleImage: UIImage {
        switch self {
        case .success:
            return UIImage(named: "SuccessImage")!
        case .fail:
            return UIImage(named: "FailImage")!
        case .pause:
            return UIImage(named: "PauseImage")!
        default:
            return UIImage()
        }
    }
    
    var hasStroke: Bool {
        switch self {
        case .success:
            return true
        case .fail, .pause:
            return false
        default:
            return false
        }
    }
}
