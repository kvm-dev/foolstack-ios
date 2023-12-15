//
//  XCTExtension.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation
import XCTest

extension XCTestCase {
    func assertIsSuccess<T, E>(
        _ result: Result<T, E>,
        then assertions: (T) -> Void = { _ in },
        message: (E) -> String = { "Expected to be a success but got a failure with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) where E: Error {
        switch result {
        case .failure(let error):
            XCTFail(message(error), file: file, line: line)
        case .success(let value):
            assertions(value)
        }
    }

    func assertIsFailure<T, E>(
        _ result: Result<T, E>,
        then assertions: (E) -> Void = { _ in },
        message: (T) -> String = { "Expected to be a failure but got a success with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) where E: Error {
        switch result {
        case .failure(let error):
            assertions(error)
        case .success(let value):
            XCTFail(message(value), file: file, line: line)
        }
    }
}
