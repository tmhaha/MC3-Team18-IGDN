//
//  Tutorial.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

struct TutorailView: View {
    
    
    @State var buttonsActivated: [Activate]
    private let opacity: Double = 0.8
    var bottomText: String
    var topText: String
    var delegate: ViewDismissDelegate? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(opacity)
                .reverseMask {
                    VStack {
                        HStack {
                            Circle().foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            Circle().foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Circle().foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            Circle().foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                        }
                    }
                    .ignoresSafeArea()
                    .padding(.leading, 39)
                    .padding(.trailing, 39)
                    .padding(.bottom ,63)
                    .padding(.top ,63)
                }
            
            VStack {
                HStack {
                    Circle()
                        .foregroundColor(buttonsActivated.contain(.changeRed) ? .white.opacity(0.001) : .black.opacity(0.8))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if buttonsActivated.contain(.changeRed) {
                                buttonsActivated.removeAll(where: { $0 == .changeRed})
                                if buttonsActivated.isEmpty {
                                    delegate?.dismiss()
                                }
                            }
                        }
                    
                    Spacer()
                    
                    Circle()
                        .foregroundColor(buttonsActivated.contain(.turnClockWise) ? .white.opacity(0.001) : .black.opacity(opacity))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if buttonsActivated.contain(.turnClockWise) {
                                buttonsActivated.removeAll(where: { $0 == .turnClockWise})
                                if buttonsActivated.isEmpty {
                                    delegate?.dismiss()
                                }
                            }
                        }
                }
                
                VStack {
                    HStack(alignment: .center) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 100)
                                .foregroundColor(.white)
                            
                            TypingAnimationView(textToType: topText)
                                .padding(7)
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(-180))
                            
                        }
                        Image("SuccessImage")
                    }
                    Spacer(minLength: 100)
                    HStack(alignment: .center) {
                        Image("SuccessImage")
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 100)
                                .foregroundColor(.white)
                            TypingAnimationView(textToType: bottomText)
                                .foregroundColor(.black)
                                .padding(7)
                        }
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                HStack {
                    Circle()
                        .foregroundColor(buttonsActivated.contain(.turnCounterClockWise) ? .white.opacity(0.001) : .black.opacity(opacity))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if buttonsActivated.contain(.turnCounterClockWise) {
                                buttonsActivated.removeAll(where: { $0 == .turnCounterClockWise})
                                if buttonsActivated.isEmpty {
                                    delegate?.dismiss()
                                }
                            }
                        }
                    
                    Spacer()
                    
                    Circle().foregroundColor(buttonsActivated.contain(.changeGreen) ? .white.opacity(0.001) : .black.opacity(opacity))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            
                            if buttonsActivated.contain(.changeGreen) {
                                buttonsActivated.removeAll(where: { $0 == .changeGreen})
                                if buttonsActivated.isEmpty {
                                    delegate?.dismiss()
                                }
                            }
                        }
                }
            }
            .ignoresSafeArea()
            .padding(.leading, 39)
            .padding(.trailing, 39)
            .padding(.bottom ,63)
            .padding(.top ,63)
        }
        .ignoresSafeArea()
    }
}

extension TutorailView {
    
    enum Activate {
        case turnClockWise
        case turnCounterClockWise
        case changeGreen
        case changeRed
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        TutorailView(buttonsActivated: [.changeGreen, .turnClockWise], bottomText: "hahahahahahahahahahahahahahahahㄴㅇㄴㅇㄴㅇㄴㅇㄴㅇㄴㅇㄴㅇahahaha", topText: "lkddfsjkldfskljdfslkjdsfjklsdlfkj")
    }
}


