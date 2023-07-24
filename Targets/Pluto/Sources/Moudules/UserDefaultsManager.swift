//
//  UserDefaultsManager.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/19.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    
    static func saveCreativeMapsToUserDefaults(_ creativeMaps: [CreativeMapModel]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(creativeMaps) {
            UserDefaults.standard.set(encodedData, forKey: "creativeMaps")
        }
    }

    static func loadCreativeMapsFromUserDefaults() -> [CreativeMapModel]? {
        if let encodedData = UserDefaults.standard.data(forKey: "creativeMaps") {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([CreativeMapModel].self, from: encodedData) {
                return decodedData
            }
        }
        return nil
    }
}
