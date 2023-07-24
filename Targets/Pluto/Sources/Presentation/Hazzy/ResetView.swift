//
//  ResetView.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/14.
//

import SwiftUI

struct ResetView: View {
    @Binding var showResetView: Bool
    
    var body: some View {
        ZStack {
            SettingData.shared.selectedTheme.origin
                .ignoresSafeArea()
                .opacity(0.8)
            VStack {
                Spacer()
                Spacer()
                
                Image("warn_white").resizable().frame(width: 63, height: 60)
                Text("Are you sure\n reset your journey?")
                    .font(.custom(tasaExplorerBold, size: 28))
                    .multilineTextAlignment(.center)
                Text("*All data will be lost!")
                    .font(.custom(tasaExplorerRegular, size: 14))
                    .padding(.top, -10)
                    .padding(.bottom, 20)

                Button {
                    showResetView.toggle()
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 262, height: 45)
                        Text("return to setting")
                            .font(.custom(tasaExplorerBold, size: 18))
                            .foregroundColor(SettingData.shared.selectedTheme.origin)
                    }
                }
                
                Button {
                    // Data Reset
                    showResetView.toggle()
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 262, height: 45)
                            .foregroundColor(.red)
                        Text("reset")
                            .font(.custom(tasaExplorerBold, size: 18))
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
        }
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView(showResetView: .constant(true))
    }
}
