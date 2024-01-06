//
//  AsyncExtentions.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 01.11.2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
