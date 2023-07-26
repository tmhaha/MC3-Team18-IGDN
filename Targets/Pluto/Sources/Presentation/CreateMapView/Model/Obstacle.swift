//
//  Obstacle.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/19.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation

struct Obstacle {
    static let color: [String] = [
        "creative_color_white",
        "creative_color_red",
        "creative_color_yellow",
        "creative_color_green"
    ]
    
    static let size: [String] = [
        "creative_size_1x",
        "creative_size_2x",
        "creative_size_3x"
    ]
    
    static let shape: [String] = [
        "creative_shape_circle",
        "creative_shape_rectangle",
        "creative_shape_triangle",
        "creative_shape_diamond"
    ]
    
    static let isClockWise: [Bool] = [
        false,
        true,
        true,
        false
    ]
    
    static let image: [[[String]]] = [
        [
            ["circle_50_white",
             "rectangle_50_white",
             "triangle_50_white",
             "diamond_50_white"
            ],
            ["circle_70_white",
             "rectangle_70_white",
             "triangle_70_white",
             "diamond_70_white"
            ],
            ["circle_100_white",
             "rectangle_100_white",
             "triangle_100_white",
             "diamond_100_white"
            ]
        ],
        [
            ["circle_50_red",
             "rectangle_50_red",
             "triangle_50_red",
             "diamond_50_red"
            ],
            ["circle_70_red",
             "rectangle_70_red",
             "triangle_70_red",
             "diamond_70_red"
            ],
            ["circle_100_red",
             "rectangle_100_red",
             "triangle_100_red",
             "diamond_100_red"
            ]
        ],
        [
            ["circle_50_yellow",
             "rectangle_50_yellow",
             "triangle_50_yellow",
             "diamond_50_yellow"
            ],
            ["circle_70_yellow",
             "rectangle_70_yellow",
             "triangle_70_yellow",
             "diamond_70_yellow"
            ],
            ["circle_100_yellow",
             "rectangle_100_yellow",
             "triangle_100_yellow",
             "diamond_100_yellow"
            ]
        ],
        [
            ["circle_50_green",
             "rectangle_50_green",
             "triangle_50_green",
             "diamond_50_green"
            ],
            ["circle_70_green",
             "rectangle_70_green",
             "triangle_70_green",
             "diamond_70_green"
            ],
            ["circle_100_green",
             "rectangle_100_green",
             "triangle_100_green",
             "diamond_100_green"
            ]
        ],
    ]
}
