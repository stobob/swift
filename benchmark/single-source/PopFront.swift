//===--- PopFront.swift ---------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import TestsUtils

let reps = 1
let arrayCount = 1024

@inline(never)
public func run_PopFrontArray(N: Int) {
  let orig = Array(count: arrayCount, repeatedValue: 1)
  var a = [Int]()
  for _ in 1...20*N {
    for _ in 1...reps {
      var result = 0
      a.appendContentsOf(orig)
      while a.count != 0 {
        result += a[0]
        a.removeAtIndex(0)
      }
      CheckResults(result == arrayCount, "IncorrectResults in StringInterpolation: \(result) != \(arrayCount)")
    }
  }
}

@inline(never)
public func run_PopFrontUnsafePointer(N: Int) {
  var orig = Array(count: arrayCount, repeatedValue: 1)
  let a = UnsafeMutablePointer<Int>.alloc(arrayCount)
  for _ in 1...100*N {
    for _ in 1...reps {
      for i in 0..<arrayCount {
        a[i] = orig[i]
      }
      var result = 0
      var count = arrayCount
      while count != 0 {
        result += a[0]
        a.assignFrom(a + 1, count: count - 1)
        count -= 1
      }
      CheckResults(result == arrayCount, "IncorrectResults in StringInterpolation: \(result) != \(arrayCount)")
    }
  }
  a.dealloc(arrayCount)
}

