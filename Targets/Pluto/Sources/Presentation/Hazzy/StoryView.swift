

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var router: Router<Path>
    let story = stages[GameData.shared.selectedStage].startStory?.text ?? []
    @State var idx1P: Int = 0
    @State var idx2P: Int = 0
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                TypingEffectTextView(messages: story, index: idx1P)
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: 330, height: 130, alignment: .trailing)
                    .foregroundColor(.black)
                    .padding(.horizontal)

                Button {
                    if (idx1P < story.count - 1) {
                        idx1P += 1
                    }
                } label: {
                    Image("PolygonUp")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 15)
                        .padding()
                }
            }

            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .frame(height: 504)
                    .foregroundColor(SettingData.shared.selectedTheme.main)
                Button {
                    router.pop()
                    SoundManager.shared.playBackgroundMusic(SoundManager.shared.chaterMusics[GameData.shared.selectedStage])
                    SoundManager.shared.playAmbience(SoundManager.shared.allAmbienceCases[GameData.shared.selectedStage])
                    AppDelegate.vc?.pushViewController(GameViewController(gameConstants: GameConstants(), map: stages[GameData.shared.selectedStage].map), animated: false)
                } label: {
                    Image("Button_skip_white")
                        .resizable()
                        .frame(width: 25, height: 20)
                        .padding()
                }
            }

            ZStack(alignment: .bottomTrailing) {
                TypingEffectTextView(messages: story, index: idx2P)
                    .frame(width: 330, height: 130, alignment: .leading)
                    .foregroundColor(.black)
                    .padding(.horizontal)

                Button {
                    if (idx2P < story.count - 1) {
                        idx2P += 1
                    }
                } label: {
                    Image("PolygonDown")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 15)
                        .padding()
                }
            }
        }
        .foregroundColor(SettingData.shared.selectedTheme.main)
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}

struct TypingEffectTextView: View {
    let messages: [String]
    let index: Int
    @State private var animateTitle: String = ""
    @State private var indexValue: Int = 0
    @State private var timeInterval: TimeInterval = 0.1

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
                }
            }
        }
    }
}
