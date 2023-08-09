//
//  HomeView.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/07.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router<Path>
    @State var isStageCleared: Bool = true
    @State var isBackgroundAppear: Bool = false
    @State var isAnimating: Bool = false

    var body: some View {
        ZStack {
            BackgroundLayer()
            if isBackgroundAppear == true {
                Group {
                    LogoLayer(isStageCleared: $isStageCleared)
                    ButtonLayer(isStageCleared: $isStageCleared)
                }
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeIn(duration: 1.5), value: isAnimating)
                .onAppear { isAnimating = true }
            }
        }
        .foregroundColor(SettingData.shared.selectedTheme.main)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isBackgroundAppear = true
            }
        }
    }
}

// MARK: Background
struct BackgroundLayer: View {
    @State var isAnimating: Bool = false
    @State var onboardingState: Int = 1
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 800, height: 800)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : -200)
                .animation(.easeInOut(duration: 1), value: isAnimating)
                .onAppear { isAnimating = true }
            Rectangle()
                .frame(height: 250)
                .foregroundColor(.white)
        }
        .frame(width: 390, height: 844)
    }
}


// MARK: Logo
struct LogoLayer: View {
    @Binding var isStageCleared: Bool
    @EnvironmentObject var settingData: SettingData
    
    var body: some View {
        VStack {
            Spacer()
            Image(isStageCleared ? "HomeCircle" : settingData.selectedTheme.plutoImage2)
                .resizable()
                .scaledToFit()
                .frame(width: 172, height: isStageCleared ? 172 : 109)
                .padding(.bottom)
            Image("Logo_white")
                .resizable()
                .scaledToFit()
                .frame(width: 248, height: 80)
            Spacer()
            Spacer()
            if isStageCleared {
                Spacer()
            }
        }
    }
}

// MARK: Button
struct ButtonLayer: View {
    @EnvironmentObject var router: Router<Path>
    @Binding var isStageCleared: Bool
    @State var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            Color.clear
            gameButton
            Spacer(minLength: 100)
            settingButton
            Spacer(minLength: 100)
        }
    }
    
    var gameButton: some View {
        let cornerRadius: CGFloat = 25
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 45
        let buttonStroke: CGFloat = 1
        let shadowRadius: CGFloat = 2
        let fontSize: CGFloat = 18
        
        return VStack {
            Button {
                router.push(.Stage)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(SettingData.shared.selectedTheme.cover)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: buttonStroke)
                        .shadow(color: .white, radius: shadowRadius)
                    Text("journey mode")
                        .font(.custom(tasaExplorerBold, size: fontSize))
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .foregroundColor(.white)
            }
            .padding(.bottom, 5)

            Button {
                if isStageCleared {
                    var mapList: [CreativeMapModel]
                    if let loadedMapList = UserDefaultsManager.loadCreativeMapsFromUserDefaults() {
                        mapList = loadedMapList
                    } else {
                        mapList = []
                    }
                    AppDelegate.vc?.present(CreateModeViewController(with: CreateModeViewModel(mapList: mapList)))
                } else {
                    isAnimating.toggle()
                    hapticFeedback(style: .soft, duration: 0.5, interval: 0.1)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(SettingData.shared.selectedTheme.cover)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: buttonStroke)
                        .shadow(color: .white, radius: shadowRadius)
                    if !isStageCleared {
                        HStack {
                            Text("creative mode")
                                .font(.custom(tasaExplorerBold, size: fontSize))
                            Image(systemName: "lock.fill")
                                .resizable()
                                .frame(width: 15, height: 20)
                                .offset(x: isAnimating ? 5 : 0)
                                .animation(Animation.easeInOut(duration: 0.1).repeatCount(5), value: isAnimating)
                        }
                    } else {
                        ZStack {
                            Text("creative mode")
                                .font(.custom(tasaExplorerBold, size: fontSize))
                            Image("Ellipse")
                                .padding(.leading, 130)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .foregroundColor(.white)
                .opacity(isStageCleared ? 1 : 0.5)
            }
        }
    }
    
    var settingButton: some View {
        Button {
            router.push(.Setting)
        } label: {
            Text("settings")
                .font(.custom(tasaExplorerRegular, size: 16))
                .underline()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
