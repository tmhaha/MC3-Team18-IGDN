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
        VStack {
            Image("Logo_blue")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(SettingData.shared.selectedTheme.main)
                .scaledToFit()
                .frame(width: 240, height: 80)
                .padding([.top, .trailing], 50)
            Spacer()
            Image(SettingData.shared.selectedTheme.plutoImage1)
                .resizable()
                .scaledToFit()
                .frame(width: 282, height: 178)
                .padding(.bottom, 70)
            Text("Touch to start")
                .font(.custom(tasaExplorerBold, size: 20))
            Spacer()
        }.onTapGesture { showSplashView.toggle() }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(showSplashView: .constant(true))
    }
}
