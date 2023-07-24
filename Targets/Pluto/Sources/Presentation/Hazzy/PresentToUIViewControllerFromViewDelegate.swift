//
//  PresentToUIViewControllerFromView.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/24.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

protocol PresentToUIViewControllerFromView {
    func present(_ vc: UIViewController, _ animatied: Bool)
}
