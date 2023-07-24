//
//  Tutorial.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

struct TutorailView: View {
    
    @State var buttonsActivated: [Activate] = []
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
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
                        .foregroundColor(buttonsActivated.contain(.changeRed) ? .white.opacity(0.001) : .gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if buttonsActivated.contain(.changeRed) {
                                buttonsActivated.removeAll(where: { $0 == .changeRed})
                                if buttonsActivated.isEmpty {
                                    
                                }
                            }
                        }

                    Spacer()

                    Circle()
                        .foregroundColor(buttonsActivated.contain(.turnClockWise) ? .white.opacity(0.001) : .gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if buttonsActivated.contain(.turnClockWise) {
                                buttonsActivated.removeAll(where: { $0 == .turnClockWise})
                                if buttonsActivated.isEmpty {
                                   
                                    
                                }
                            }
                        }
                }

                Spacer()

                HStack {
                    Circle()
                        .foregroundColor(buttonsActivated.contain(.turnCounterClockWise) ? .white.opacity(0.001) : .gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if buttonsActivated.contain(.turnCounterClockWise) {
                                buttonsActivated.removeAll(where: { $0 == .turnCounterClockWise})
                                if buttonsActivated.isEmpty {
                                    
                                }
                            }
                        }

                    Spacer()

                    Circle().foregroundColor(buttonsActivated.contain(.changeGreen) ? .white.opacity(0.001) : .gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            
                            if buttonsActivated.contain(.changeGreen) {
                                buttonsActivated.removeAll(where: { $0 == .changeGreen})
                                if buttonsActivated.isEmpty {
                                    
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
//        .padding(.top, 20)
//        .padding(.bottom, 20)
    }
    
    func makeUIView() -> UIView {
        UIHostingController(rootView: self).view
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
        TutorailView()
    }
}


