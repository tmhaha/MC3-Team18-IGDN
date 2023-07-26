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

    var main: Color {
        switch self {
        case .blue:
            return Color(hex: "002EFE")
        case .orange:
            return Color(hex: "FF7F04")
        case .lime:
            return Color.green
        }
    }

    
    var cover: Color {
        switch self {
        case .blue:
            return Color(hex: "002EFE").opacity(0.75)
        case .orange:
            return Color(hex: "FF7F04").opacity(0.75)
        case .lime:
            return Color.green.opacity(0.5)
        }
    }
    
    var creative: Color {
        switch self {
        case .blue:
            return Color(hex: "2244FF")
        case .orange:
            return Color(hex: "FFA54E")
        case .lime:
            return Color.green.opacity(0.5)
        }
    }
    
    var grid: Color {
        switch self {
        case .blue:
            return Color(hex: "4061F8")
        case .orange:
            return Color(hex: "F5771C")
        case .lime:
            return Color.green.opacity(0.5)
        }
    }
    
    var mainLight: Color {
        switch self {
        case .blue:
            return Color(hex: "B4C1FF")
        case .orange:
            return Color(hex: "FFBB81")
        case .lime:
            return Color.green.opacity(0.5)
        }
    }

    var lockedMain: Color {
        switch self {
        case .blue:
            return Color(hex: "00198C")
        case .orange:
            return Color(hex: "C55D00")
        case .lime:
            return Color.green.opacity(0.5)
        }
    }
    
    var lockedWhite: Color {
        switch self {
        case .blue:
            return Color(hex: "8996D1")
        case .orange:
            return Color(hex: "D9A77F")
        case .lime:
            return Color.green.opacity(0.5)
        }
    }
    
    var warnRed: Color {
        switch self {
        case .blue:
            return Color(hex: "ED5959")
        case .orange:
            return Color(hex: "ED5959")
        case .lime:
            return Color(hex: "ED5959")
        }
    }
    
    var white: Color {
        switch self {
        case .blue:
            return Color(hex: "FFFFFF")
        case .orange:
            return Color(hex: "FFFFFF")
        case .lime:
            return Color(hex: "FFFFFF")
        }
    }
    
    var gray: Color {
        switch self {
        case .blue:
            return Color(hex: "E6E7E7")
        case .orange:
            return Color(hex: "E6E7E7")
        case .lime:
            return Color(hex: "E6E7E7")
        }
    }
    
    var black: Color {
        switch self {
        case .blue:
            return Color(hex: "000000")
        case .orange:
            return Color(hex: "000000")
        case .lime:
            return Color(hex: "000000")
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

let allThemeCases: [Theme] = Theme.allCases

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
