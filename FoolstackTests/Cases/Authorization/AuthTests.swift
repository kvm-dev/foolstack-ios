//
//  AuthTests.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 19.01.2024.
//

import XCTest
@testable import Foolstack

final class AuthTests: XCTestCase {
    var sut: NetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockNetworkClient()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    @MainActor
    func test_setWrongEmail_confirmButtonDisabled() throws {
        let vm = AuthVM_SignIn(network: sut)
        vm.firstFieldText = "fff#ff.tt"
        
        XCTAssertFalse(vm.nextButtonEnabled)
    }

    @MainActor
    func test_setCorrectEmail_confirmButtonEnabled() throws {
        let vm = AuthVM_SignIn(network: sut)
        vm.firstFieldText = "fff@ff.tt"
        
        XCTAssertTrue(vm.nextButtonEnabled)
    }

    @MainActor
    func test_sendCorrectEmail_successReceived() throws {
        let vm = AuthVM_SignIn(network: sut)
        vm.firstFieldText = "fff@ff.tt"
        
        let expectation = XCTestExpectation(description: "Show Auth Enter code screen")
        vm.onShowEnterCode = { _ in
            expectation.fulfill()
        }
        vm.doNext()
        
        wait(for: [expectation], timeout: 3)
    }

}
