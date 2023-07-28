//
//  ContentView.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/07.
//

import SwiftUI

struct ContentView: View {
    @State var showSplashView: Bool = true
    @StateObject var router = Router<Path>()
    @StateObject var settingData = SettingData()
    
    var body: some View {
        NavigationStack(path: $router.paths) {
            ZStack {
                if showSplashView == true {
                    SplashView(showSplashView: $showSplashView)
                } else  {
                    HomeView()
                    .navigationDestination(for: Path.self) { path in
                        switch path {
                        case .Home: HomeView().navigationBarBackButtonHidden()
                        case .Setting: SettingView().navigationBarBackButtonHidden()
                        case .Stage: SelectStageView().navigationBarBackButtonHidden()
                        case .Story: StoryView().navigationBarBackButtonHidden()
                        }
                    }
                }
            }
        }
        .environmentObject(router)
        .environmentObject(settingData)
        .onAppear {
            _ = SoundManager.shared
        }
    }
}

final class Router<T: Hashable>: ObservableObject {
    @Published var paths: [T] = []
    func push(_ path: T) {
        paths.append(path)
    }
    
    func pop() {
        paths.removeLast(1)
    }
    
    func pop(to: T) {
        guard let found = paths.firstIndex(where: { $0 == to }) else {
            return
        }

        let numToPop = (found..<paths.endIndex).count - 1
        paths.removeLast(numToPop)
    }
    
    func popToRoot() {
        paths.removeAll()
    }
}

enum Path {
    case Home
    case Setting
    case Stage
    case Story
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
