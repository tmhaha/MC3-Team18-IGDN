//
//  ShowAlert.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/17.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation

protocol ShowAlertDelegate {
    func showAlert(alertType: GameAlertType)
    func showTutorial(tutorials: [GameAlertType])
}
