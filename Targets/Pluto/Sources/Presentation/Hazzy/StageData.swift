//
//  StageData.swift
//  Pluto
//
//  Created by 고혜지 on 2023/07/27.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

let stages:[Stage] = [
    Stage(level: 1, startStory: [], endStory: nil, path: []),
    Stage(level: 2, startStory: nil, endStory: nil, path: []),
    Stage(level: 3, startStory: nil, endStory: nil, path: []),
    Stage(level: 4, startStory: nil, endStory: nil, path: []),
    Stage(level: 5, startStory: nil, endStory: nil, path: []),
    Stage(level: 6, startStory: [], endStory: [], path: [])
]

struct Stage {
    let level: Int
    let startStory: [(Image, [String])]?
    let endStory: [(Image, [String])]?
    let path: [String] // 자료형 잘 모르겠음
// 속도 등...
//    let speed: CGFloat
//    let ...
}
