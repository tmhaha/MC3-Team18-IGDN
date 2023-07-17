//
//  CreativeMapModel.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/12.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

struct CreativeMapModel {
    var titleLabel: String
    var lastEdited: Date
    var objectList: [CreativeObject]
    
    func lastEditedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd:HH:mm"
        return dateFormatter.string(from: lastEdited)
    }
}
