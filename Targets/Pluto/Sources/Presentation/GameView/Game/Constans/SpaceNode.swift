//
//  SpaceNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/31.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

struct SpaceNode: View {
    
    var body: some View {
        Image("BackGround")
            .resizable()
            .ignoresSafeArea()
    }
}

struct SpaceNodePreviewer: PreviewProvider {
    static var previews: some View {
        SpaceNode()
    }
}
