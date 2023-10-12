//
//  CurrencyConversionCase.swift
//  CurrencyConversionTests
//
//  Created by Barani Elangovan on 12/10/2023.
//

import XCTest
@testable import CurrencyConversion

final class CurrencyConversionCase: XCTestCase {

    var viewModel = CurrencyConversionViewModel()

    // MARK: - Test Case For Amount TextField Success

    func test_ValidAmount() throws{
        let isValidAmount = viewModel.currencyTextfieldValidation(textfieldSring: "233")
        XCTAssertTrue(isValidAmount)
    }
    
    // MARK: - Test Case For Amount TextField Failed

    func test_ValidAmount1() throws{
        let isValidAmount = viewModel.currencyTextfieldValidation(textfieldSring: "ewe")
        XCTAssertFalse(isValidAmount)
    }
    func test_ValidAmount2() throws{
        let isValidAmount = viewModel.currencyTextfieldValidation(textfieldSring: "233.737.33")
        XCTAssertFalse(isValidAmount)
    }
    func test_ValidAmount3() throws{
        let isValidAmount = viewModel.currencyTextfieldValidation(textfieldSring: "233.737")
        XCTAssertTrue(isValidAmount)
    }
    func test_ValidAmount4() throws{
        let isValidAmount = viewModel.currencyTextfieldValidation(textfieldSring: "233.737wwd")
        XCTAssertFalse(isValidAmount)
    }
    
    // MARK: - Test Case For Insert Core Data Success

    func test_InsertCoreData() throws{
        XCTAssertTrue(viewModel.insertCurrency(currencyCode: "USD", amount: 1))
    }
    func test_InsertCoreData1() throws{
        XCTAssertFalse(viewModel.insertCurrency(currencyCode: nil, amount: nil))
        XCTAssertFalse(viewModel.insertCurrency(currencyCode: "", amount: nil))
        XCTAssertFalse(viewModel.insertCurrency(currencyCode: "USD", amount: nil))
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
