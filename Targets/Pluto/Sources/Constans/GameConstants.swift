//
//  GameConstants.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/16.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation

struct GameConstans {
    
    static let astronautSpeed: CGFloat = 100 // 1초동안 아주 작은 거리 만큼 이동함
    static let astronuatAngle: CGFloat = CGFloat.pi / 30 // 현재는 6도 정도 매우 짧은 시간동안 꺽이는 중
    static let planetFindContactPointDuration: CGFloat = 0.5 // 궤도가 닿은 지점을 찾는 시간
    static let planetOrbitDuration: CGFloat = 0.1 // 궤도가 닿은 지점을 찾은후 궤도를 도는 속도
    static let backgroundFirstLayerDuration: CGFloat = 5 // 첫번째 배경레이어의 횡 시간
    static let backgroundSecondLayerDuration: CGFloat = 10 // 두번째 배경레이어의 횡 시간
    static let backgroundThirdLayerDuration: CGFloat = 20 // 세번째 배경레이어의 횡 시간
    static let planetsDistance: Int = 7 // 현재는 3초에 하나씩 옮
    static let planetDuration: CGFloat = 20 // 현재는 -100좌표까지 15초 동안 감
}
