//
//  TutorialFinishDelegate.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/27.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

protocol TutorialFinishDelegate {
    func finish(_ touches: Set<UITouch>, with event: UIEvent?, endedType: Int)
}
