//
//  UIViewController+.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/24.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

extension UINavigationController: PresentToUIViewControllerFromViewDelegate {
    
    func present(_ vc: UIViewController, _ animatied: Bool = false) {
        self.pushViewController(vc, animated: animatied)
    }
}
