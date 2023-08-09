//
//  StoryView.swift
//  Pluto
//
//  Created by 고혜지 on 2023/07/27.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var router: Router<Path>
    @State var isDone: Int = 0
    @State var idx: Int = 0
    
    var body: some View {
        ZStack {
            StoryImageView(idx: $idx)
            
            VStack {
                StoryTextView(player: 2, idx: $idx, isDone: $isDone)
                
                Spacer()
                
                SkipButtonView()

                StoryTextView(player: 1, idx: $idx, isDone: $isDone)
            }
            .padding(.vertical)
        }
        .onChange(of: isDone) { newValue in
            if newValue == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    router.pop()
                    StartGame()
                }
            }
        }
    }
}

struct StoryImageView: View {
    @Binding var idx: Int
    let images: [String] = stages[GameData.shared.selectedStage].startStory.image
    let effects: [ImageEffect] = stages[GameData.shared.selectedStage].startStory.imageEffect
    
    var body: some View {
        switch effects[idx] {
        case .cut:
            Image(images[idx])
                .resizable()
                .ignoresSafeArea()
        case .fadeIn:
            FadeInImage(image: images[idx])
        case .fadeOut:
            FadeOutImage(image: images[idx])
        case .blink:
            BlinkImage()
        }
    }
}

struct FadeInImage: View {
    @State var isAnimating: Bool = false
    let image: String
    
    var body: some View {
        return Image(image)
            .resizable()
            .ignoresSafeArea()
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(.easeIn(duration: 2), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
            .background(.black)
    }
}

struct FadeOutImage: View {
    @State var isAnimating: Bool = false
    let image: String
    
    var body: some View {
        return Image(image)
            .resizable()
            .ignoresSafeArea()
            .opacity(isAnimating ? 0.0 : 1.0)
            .animation(.easeIn(duration: 2), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
            .background(.black)
    }
}

struct BlinkImage: View {
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Image("1_3")
                .resizable()
                .ignoresSafeArea()
            Image("1_4")
                .resizable()
                .ignoresSafeArea()
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.12).repeatCount(3), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}


struct StoryTextView: View {
    let story = stages[GameData.shared.selectedStage].startStory.text
    var player: Int
    @State var buttonOn: Bool = false
    @Binding var idx: Int
    @Binding var isDone: Int
    
    var body: some View {
        ZStack {
            backgroundLayer
            textLayer
            buttonLayer
        }
        .frame(width:390, height: 110)
    }
    
    private var backgroundLayer: some View {
        Image(player == 1 ? "StoryTextBackground" : "StoryTextBackgroundReverse")
    }
    
    private var textLayer: some View {
        VStack {
            Text(stages[GameData.shared.selectedStage].startStory.character[idx])
                .frame(width: 345, height: 20, alignment: .leading)
                .font(.custom(tasaExplorerBold, size: 18))
                .opacity(0.7)
                .padding(.top)
            TypingEffectTextView(messages: story, index: idx, buttonOn: $buttonOn, isDone: $isDone)
                .frame(width: 345, alignment: .leading)
                .multilineTextAlignment(.leading)
                .font(.custom(notoSansMedium, size: 18))
            Spacer()
        }
        .rotationEffect(Angle(degrees: player == 1 ? 0 : 180))
        .foregroundColor(.white)
    }
    
    private var buttonLayer: some View {
        Button {
            if buttonOn {
                if (idx < story.count - 1) {
                    idx += 1
                }
                buttonOn = false
            }
        } label: {
            Image(player == 1 ? "PolygonDown" : "PolygonUp")
                .resizable()
                .frame(width: 20, height: 13)
                .opacity(buttonOn ? 1 : 0.3)
                .padding()
        }
        .frame(width: 390, height: 110, alignment: player == 1 ? .bottomTrailing : .topLeading)
    }
}

struct SkipButtonView: View {
    @EnvironmentObject var router: Router<Path>
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                router.pop()
                StartGame()
            } label: {
                Image("Button_skip_white")
                    .resizable()
                    .frame(width: 25, height: 20)
                    .padding(.horizontal)
            }
        }
    }
}

struct TypingEffectTextView: View {
    let messages: [String]
    let index: Int
    @State private var animateTitle: String = ""
    @State private var indexValue: Int = 0
    @State private var timeInterval: TimeInterval = 0.05
    @Binding var buttonOn: Bool
    @Binding var isDone: Int

    var body: some View {
        VStack {
            Text(animateTitle)
                .onChange(of: index) { newIndex in
                    animateTitle = ""
                    indexValue = 0
                    Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
                        if indexValue < messages[index+1].count {
                            animateTitle += String(messages[index+1][messages[index+1].index(messages[index+1].startIndex, offsetBy: indexValue)])
                            indexValue += 1
                        } else  {
                            timer.invalidate()
                            buttonOn = true
                            if newIndex == messages.count - 1 {
                                isDone += 1
                            }
                        }
                    }
                }
        }
        .onAppear {
            animateTitle = ""
            indexValue = 0
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
                if indexValue < messages[index].count {
                    animateTitle += String(messages[index][messages[index].index(messages[index].startIndex, offsetBy: indexValue)])
                    indexValue += 1
                } else  {
                    timer.invalidate()
                    buttonOn = true
                }
            }
        }
    }
}

private func StartGame() {
//    SoundManager.shared.playBackgroundMusic(SoundManager.shared.chaterMusics[GameData.shared.selectedStage])
//    SoundManager.shared.playAmbience(SoundManager.shared.allAmbienceCases[GameData.shared.selectedStage])

    // TODO: 챕터별 음악이랑 앰비언스 아직 없어서 일단 이렇게 둠
    SoundManager.shared.playBackgroundMusic(SoundManager.shared.chaterMusics[0])
    SoundManager.shared.playAmbience(SoundManager.shared.allAmbienceCases[0])
    
    AppDelegate.vc?.pushViewController(GameViewController(gameConstants: GameConstants(), map: stages[GameData.shared.selectedStage].map), animated: false)
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
