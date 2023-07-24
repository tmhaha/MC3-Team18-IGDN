//
//  Array+.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation

extension Array where Element == TutorailView.Activate {
    
    func contain(_ button: TutorailView.Activate) -> Bool {
        contains(where: { $0 == button })
    }
}
