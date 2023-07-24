//
//  AppData.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/14.
//

import SwiftUI

// Theme
enum Theme: Int, CaseIterable {
    case blue = 0
    case orange = 1
    case lime = 2
        
    var name: String {
        switch self {
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        case .lime:
            return "green"
        }
    }

    var origin: Color {
        switch self {
        case .blue:
            return Color(hex: "002EFE")
        case .orange:
            return Color.orange
        case .lime:
            return Color.green
        }
    }

    var light: Color {
        switch self {
        case .blue:
            return Color(hex: "B4C1FF")
        case .orange:
            return Color.orange.opacity(0.5)
        case .lime:
            return Color.green.opacity(0.5)
        }
    }

    var cover: Color {
        switch self {
        case .blue:
            return Color(hex: "002EFE").opacity(0.75)
        case .orange:
            return Color.orange.opacity(0.5)
        case .lime:
            return Color.green.opacity(0.5)
        }
    }

    var pressed: Color {
        switch self {
        case .blue:
            return Color(hex: "00198C")
        case .orange:
            return Color.orange.opacity(0.5)
        case .lime:
            return Color.green.opacity(0.5)
        }
    }
    
//    var pauseButtonImage: String { // todo
//        switch self {
//        case .blue:
//            return
//        case .orange:
//            return
//        case .lime:
//            return
//        }
//    }
//
//    var spinImage: String { // todo
//        switch self {
//        case .blue:
//            return
//        case .orange:
//            return
//        case .lime:
//            return
//        }
//    }
}

let allCase: [Theme] = Theme.allCases

// Onboarding
let story: [(String, String)] = [
    ("Title 1", "Lorem ipsum dolor sit amet, cons ecteadipiscing elit. Nulla sagittis bibe ndum vulputate. Donec pul yayaya."),
    ("Title 2", "story 2"),
    ("Title 3", "story 3")
]

// Font
let tasaExplorerBlack = "TASAExplorer-Black"
let tasaExplorerBold = "TASAExplorer-Bold"
let tasaExplorerMedium = "TASAExplorer-Medium"
let tasaExplorerRegular = "TASAExplorer-Regular"
let tasaExplorerSemiBold = "TASAExplorer-SemiBold"
