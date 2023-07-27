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
    case gray = 2
        
    var name: String {
        switch self {
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        case .gray:
            return "Gray"
        }
    }

    var main: Color {
        switch self {
        case .blue:
            return Color(hex: "002EFE")
        case .orange:
            return Color(hex: "FF7F04")
        case .gray:
            return Color(hex: "292929")
        }
    }
    
    var cover: Color {
        switch self {
        case .blue:
            return Color(hex: "002EFE").opacity(0.75)
        case .orange:
            return Color(hex: "FF7F04").opacity(0.75)
        case .gray:
            return Color(hex: "292929").opacity(0.75)
        }
    }
    
    var creative: Color {
        switch self {
        case .blue:
            return Color(hex: "2244FF")
        case .orange:
            return Color(hex: "FFA54E")
        case .gray:
            return Color(hex: "444444")
        }
    }
    
    var grid: Color {
        switch self {
        case .blue:
            return Color(hex: "4061F8")
        case .orange:
            return Color(hex: "F5771C")
        case .gray:
            return Color(hex: "9F9F9F")
        }
    }
    
    var mainLight: Color {
        switch self {
        case .blue:
            return Color(hex: "B4C1FF")
        case .orange:
            return Color(hex: "FFBB81")
        case .gray:
            return Color(hex: "E1E1E1")
        }
    }

    var lockedMain: Color {
        switch self {
        case .blue:
            return Color(hex: "00198C")
        case .orange:
            return Color(hex: "C55D00")
        case .gray:
            return Color(hex: "000000")
        }
    }
    
    var lockedWhite: Color {
        switch self {
        case .blue:
            return Color(hex: "8996D1")
        case .orange:
            return Color(hex: "D9A77F")
        case .gray:
            return Color(hex: "757575")
        }
    }
    
    var warnRed: Color {
        switch self {
        case .blue:
            return Color(hex: "ED5959")
        case .orange:
            return Color(hex: "ED5959")
        case .gray:
            return Color(hex: "ED5959")
        }
    }
    
    var white: Color {
        switch self {
        case .blue:
            return Color(hex: "FFFFFF")
        case .orange:
            return Color(hex: "FFFFFF")
        case .gray:
            return Color(hex: "FFFFFF")
        }
    }
    
    var gray: Color {
        switch self {
        case .blue:
            return Color(hex: "E6E7E7")
        case .orange:
            return Color(hex: "E6E7E7")
        case .gray:
            return Color(hex: "E6E7E7")
        }
    }
    
    var black: Color {
        switch self {
        case .blue:
            return Color(hex: "000000")
        case .orange:
            return Color(hex: "000000")
        case .gray:
            return Color(hex: "000000")
        }
    }
    
    var plutoImage1: String {
        switch self {
        case .blue:
            return "pluto_blue"
        case .orange:
            return "pluto_orange"
        case .gray:
            return "pluto_gray"
        }
    }
    
    var plutoImage2: String { // todo
        switch self {
        case .blue:
            return "pluto_blue2"
        case .orange:
            return "pluto_orange2"
        case .gray:
            return "pluto_gray2"
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
