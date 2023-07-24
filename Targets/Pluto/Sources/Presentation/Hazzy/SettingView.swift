//
//  SettingView.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/07.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var router: Router<Path>
    @EnvironmentObject var settingData: SettingData
    @State var showResetView: Bool = false
        
    var body: some View {
        ZStack {
            VStack {
                navigationBar
                    .padding(.vertical)
                
                selectTheme
                    .padding(.bottom)
                
                dividingLine
                    .padding(.bottom)
                
                slider
                toggle

                Spacer()
                Spacer()
                
                spinImage
                
                Spacer()
                
                resetButton
                
            }
            .foregroundColor(SettingData.shared.selectedTheme.origin)
            .tint(SettingData.shared.selectedTheme.origin)
            
            if (showResetView) {
                ResetView(showResetView: $showResetView)
            }
        }
   }
}

extension SettingView {
    var navigationBar: some View {
        ZStack {
            HStack {
                Spacer()
                Text("settings")
                    .font(.custom(tasaExplorerBlack, size: 32))
                Spacer()
            }
            
            HStack {
                Button {
                    router.pop()
                } label: {
                    Image("arrow")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 20)
                }
                .padding(.leading, 40)
                Spacer()
            }
        }
    }
    
    var selectTheme: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(SettingData.shared.selectedTheme.light)
                .frame(width: 120, height: 120)
                .padding(.trailing, 5)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                    .frame(width: 178, height: 120)
                VStack {
                    Text("Select Theme")
                        .font(.custom(tasaExplorerRegular, size: 18))
                    ZStack {
                        Rectangle()
                            .stroke(lineWidth: 2)
                            .frame(width: 150, height: 30)
                        HStack {
                            Button {
                                var index = SettingData.shared.selectedTheme.rawValue
                                if index > 0 {
                                    index -= 1
                                } else {
                                    index = allThemeCases.count - 1
                                }
                                SettingData.shared.selectedTheme = allThemeCases[index]
                            } label: {
                                Image(systemName: "arrowtriangle.left.fill")
                                    .resizable()
                                    .frame(width: 7, height: 10)
                                    .padding(.trailing, 30)
                            }
                            Text(SettingData.shared.selectedTheme.name)
                                .font(.custom(tasaExplorerBold, size: 16))
                            Button {
                                var index = SettingData.shared.selectedTheme.rawValue
                                if index < allThemeCases.count - 1 {
                                    index += 1
                                } else {
                                    index = 0
                                }
                                SettingData.shared.selectedTheme = allThemeCases[index]
                            } label: {
                                Image(systemName: "arrowtriangle.right.fill")
                                    .resizable()
                                    .frame(width: 7, height: 10)
                                    .padding(.leading, 30)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var dividingLine: some View  {
        Rectangle()
            .frame(width: 308, height: 2)
            .foregroundColor(SettingData.shared.selectedTheme.light)
    }
    
    var slider: some View {
        VStack(alignment: .leading, spacing: -5) {
            Text("Music volume")
            Slider(value: SettingData.shared.$musicVolume, in: 0.0...1.0)
                .padding(.bottom, 10)
                .onChange(of: SettingData.shared.musicVolume) { newValue in
                    SoundManager.shared.updateVolume(isBackgroundMusic: true, isAmbience: false, volume: Float(newValue))
                }
            
            Text("Effects volume")
            Slider(value: SettingData.shared.$effectVolume, in: 0.0...1.0)
                .onChange(of: SettingData.shared.effectVolume) { newValue in
                    SoundManager.shared.updateVolume(isBackgroundMusic: false, isAmbience: false, volume: Float(newValue))
                }
        }
        .font(.custom(tasaExplorerBold, size: 20))
        .padding(.horizontal, 40)
    }
    
    var toggle: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 151, height: 1.5)
                    .foregroundColor(SettingData.shared.selectedTheme.light)
                    .padding(.leading, 50)
                
                Toggle("Ambiance", isOn: SettingData.shared.$isAmbianceOn)
                    .onChange(of: SettingData.shared.isAmbianceOn, perform: { newValue in
                        SoundManager.shared.updateVolume(isBackgroundMusic: false, isAmbience: true, volume: (newValue ? 0.5 : 0))
                    })
                    .padding(.vertical, 10)
            }

            ZStack {
                Rectangle()
                    .frame(width: 182, height: 1.5)
                    .foregroundColor(SettingData.shared.selectedTheme.light)
                    .padding(.leading, 15)
                
                Toggle("Haptic", isOn: SettingData.shared.$isHapticOn)
            }
        }
        .font(.custom(tasaExplorerBold, size: 20))
        .padding(.horizontal, 40)
    }
    
    var spinImage: some View {
        Image("Spin")
            .renderingMode(.template)
            .resizable()
            .frame(width: 130, height: 82)
    }
    
    var resetButton: some View {
        Button {
            showResetView.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 310, height: 45)
                Text("reset journey")
                    .font(.custom(tasaExplorerBold, size: 18))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .padding(.top)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
