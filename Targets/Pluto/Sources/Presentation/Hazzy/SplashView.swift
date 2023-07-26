//
//  SplashView.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/10.
//

import SwiftUI

struct SplashView: View {
    @Binding var showSplashView: Bool
    
    var body: some View {
        ZStack {
            Image("Splash")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .onTapGesture { showSplashView.toggle() }
                .foregroundColor(SettingData.shared.selectedTheme.main)
                .background(Color.white)
            VStack {
                Color.clear.frame(height: 500)
                Text("Touch to start")
                    .font(.custom(tasaExplorerBold, size: 20))
            }
        }.onTapGesture { showSplashView.toggle() }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(showSplashView: .constant(true))
    }
}
