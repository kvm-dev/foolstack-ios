//
//  DataCacheService.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

protocol DataCacheService {
    func getWikis() async -> [WikiListEntity]
}
