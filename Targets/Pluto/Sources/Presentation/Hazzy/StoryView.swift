//
//  StoryView.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/14.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var router: Router<Path>
    let story1P: [(String, String)] = story
    let story2P: [(String, String)] = story
    @State var idx1P: Int = 0
    @State var idx2P: Int = 0
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading) {
                    Text(story1P[idx1P].0)
                        .font(.title)
                        .bold()
                    Text(story1P[idx1P].1)
                }
                .rotationEffect(Angle(degrees: 180))
                .frame(width: 330, height: 170, alignment: .trailing)
                .foregroundColor(.black)
                .padding(.horizontal)
                
                Button {
                    if (idx1P < story1P.count - 1) {
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
                Button {
                    // MARK: 여기서 게임 진입! (스토리O)
                    router.pop()
                    AppDelegate.vc?.pushViewController(GameViewController(gameConstants: GameConstants(), map: stages[GameData.shared.selectedStage].map), animated: false)
                } label: {
                    Image("Button_skip_white")
                        .resizable()
                        .frame(width: 25, height: 20)
                        .padding()
                }
            }
            
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    Text(story2P[idx2P].0)
                        .font(.title)
                        .bold()
                    Text(story2P[idx2P].1)
                }
                .frame(width: 330, height: 170, alignment: .leading)
                .foregroundColor(.black)
                .padding(.horizontal)
                
                Button {
                    if (idx2P < story2P.count - 1) {
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


// Typewriter Effect
struct TypeWriterView: View {
    @State var text: String = ""
    let finalText: String = "Hello, World!"
    
    var body: some View {
        VStack(spacing: 16.0) {
            Text(text)
            Button("Type") {
                typeWriter()
            }
        }
    }
    
    
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            text = ""
        }
        if position < finalText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                text.append(finalText[position])
                typeWriter(at: position + 1)
            }
        }
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
