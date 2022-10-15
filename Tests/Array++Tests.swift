//
//  Array++Tests.swift
//  
//
//  Created by Carson Rau on 10/1/22.
//

@testable import NovaCore
import XCTest

public final class ArrayExtensionTests: XCTestCase {
    func test_prepend() {
        var arr = [2, 3, 4, 5]
        arr.prepend(1)
        XCTAssertEqual(arr, [1, 2, 3, 4, 5])
    }
    func test_safeSwap() {
        var arr = [1, 2, 3, 4, 5]
        arr.safeSwap(from: 3, to: 0)
        XCTAssertEqual(arr[0], 4)
        XCTAssertEqual(arr[3], 1)
        
        var newArr = arr
        newArr.safeSwap(from: 1, to: 1)
        XCTAssertEqual(newArr, arr)
        
        newArr = arr
        newArr.safeSwap(from: 1, to: 12)
        XCTAssertEqual(newArr, arr)
        
        let emptyArr: [Int] = []
        var swappedEmptyArr = emptyArr
        swappedEmptyArr.safeSwap(from: 1, to: 3)
        XCTAssertEqual(swappedEmptyArr, emptyArr)
    }
}
