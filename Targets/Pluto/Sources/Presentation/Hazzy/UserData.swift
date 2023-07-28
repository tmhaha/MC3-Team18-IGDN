//
//  UserData.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/07.
//

import SwiftUI

class SettingData: ObservableObject {
    static let shared: SettingData = SettingData()
    init() {}
    
    @AppStorage("isAmbianceOn") var isAmbianceOn: Bool = true
    @AppStorage("isHapticOn") var isHapticOn: Bool = true
    @AppStorage("musicVolume") var musicVolume: Double = 0.5
    @AppStorage("effectVolume") var effectVolume: Double = 0.5
    @AppStorage("selectedTheme") var selectedTheme: Theme = .blue
}

class GameData: ObservableObject {
    static let shared: GameData = GameData()
    init() {}

    @AppStorage("currentStage") var currentStage: Int = 3
    @AppStorage("selectedStage") var selectedStage: Int = 1
}
