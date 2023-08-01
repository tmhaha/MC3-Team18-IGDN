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
    
    var stageImage: [Image] {
        switch self {
        case .blue:
            return [Image("stage_blue_1"), Image("stage_blue_2"), Image("stage_blue_3"), Image("stage_blue_4"), Image("stage_blue_5"), Image("stage_blue_6")]
        case .orange:
            return [Image("stage_orange_1"), Image("stage_orange_2"), Image("stage_orange_3"), Image("stage_orange_4"), Image("stage_orange_5"), Image("stage_orange_6")]
        case .gray:
            return [Image("stage_gray_1"), Image("stage_gray_2"), Image("stage_gray_3"), Image("stage_gray_4"), Image("stage_gray_5"), Image("stage_gray_6")]
        }
    }

    var creativeColor: [String] {
        switch self {
        case .blue:
            return [
                "creative_color_white",
                "creative_color_red",
                "creative_color_yellow",
                "creative_color_green"
            ]
        case .orange:
            return [
                "orange_color_white",
                "orange_color_red",
                "orange_color_yellow",
                "orange_color_green"
            ]
        case .gray:
            return [
                "gray_color_white",
                "gray_color_red",
                "gray_color_yellow",
                "gray_color_green"
            ]
        }
    }
    
    var creativeShape: [String] {
        switch self {
        case .blue:
            return [
                "creative_shape_circle",
                "creative_shape_rectangle",
                "creative_shape_triangle",
                "creative_shape_diamond"
            ]
        case .orange:
            return [
                "orange_shape_circle",
                "orange_shape_rectangle",
                "orange_shape_triangle",
                "orange_shape_diamond"
            ]
        case .gray:
            return [
                "gray_shape_circle",
                "gray_shape_rectangle",
                "gray_shape_triangle",
                "gray_shape_diamond"
            ]
        }
    }
    
    var creativeSize: [String] {
        switch self {
        case .blue:
            return [
                "creative_size_1x",
                "creative_size_2x",
                "creative_size_3x"
            ]
        case .orange:
            return [
                "orange_size_1x",
                "orange_size_2x",
                "orange_size_3x"
            ]
        case .gray:
            return [
                "gray_size_1x",
                "gray_size_2x",
                "gray_size_3x"
            ]
        }
    }

    // MARK: @KIO - In Game Image
    var buttonAreaImage: String {
        switch self {
        case .blue:
            return "button_area_blue"
        case .orange:
            return "button_area_orange"
        case .gray:
            return "button_area_gray"
        }
    }

    var pauseButtonImage: String {
        switch self {
        case .blue:
            return "pause_button_blue"
        case .orange:
            return "pause_button_orange"
        case .gray:
            return "pause_button_gray"
        }
    }

    var successAlertImage: String {
        switch self {
        case .blue:
            return "success_alert_blue"
        case .orange:
            return "success_alert_orange"
        case .gray:
            return "success_alert_gray"
        }
    }

}

let allThemeCases: [Theme] = Theme.allCases

// Font
let tasaExplorerBlack = "TASAExplorer-Black"
let tasaExplorerBold = "TASAExplorer-Bold"
let tasaExplorerMedium = "TASAExplorer-Medium"
let tasaExplorerRegular = "TASAExplorer-Regular"
let tasaExplorerSemiBold = "TASAExplorer-SemiBold"
let dungGeunMo = "DungGeunMo"
