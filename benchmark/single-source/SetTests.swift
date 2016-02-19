//===--- SetTests.swift ---------------------------------------------------===//
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

@inline(never)
public func run_SetIsSubsetOf(N: Int) {
  let size = 200

  SRand()

  var set = Set<Int>(minimumCapacity: size)
  var otherSet = Set<Int>(minimumCapacity: size)

  for _ in 0 ..< size {
    set.insert(Int(truncatingBitPattern: Random()))
    otherSet.insert(Int(truncatingBitPattern: Random()))
  }

  var isSubset = false;
  for _ in 0 ..< N * 5000 {
    isSubset = set.isSubsetOf(otherSet)
    if isSubset {
      break
    }
  }

  CheckResults(!isSubset, "Incorrect results in SetIsSubsetOf")
}

@inline(never)
func sink(inout s: Set<Int>) {
}

@inline(never)
public func run_SetExclusiveOr(N: Int) {
  let size = 400

  SRand()

  var set = Set<Int>(minimumCapacity: size)
  var otherSet = Set<Int>(minimumCapacity: size)

  for _ in 0 ..< size {
    set.insert(Int(truncatingBitPattern: Random()))
    otherSet.insert(Int(truncatingBitPattern: Random()))
  }

  var xor = Set<Int>()
  for _ in 0 ..< N * 100 {
    xor = set.exclusiveOr(otherSet)
  }
  sink(&xor)
}

@inline(never)
public func run_SetUnion(N: Int) {
  let size = 400

  SRand()

  var set = Set<Int>(minimumCapacity: size)
  var otherSet = Set<Int>(minimumCapacity: size)

  for _ in 0 ..< size {
    set.insert(Int(truncatingBitPattern: Random()))
    otherSet.insert(Int(truncatingBitPattern: Random()))
  }

  var or = Set<Int>()
  for _ in 0 ..< N * 100 {
    or = set.union(otherSet)
  }
  sink(&or)
}

@inline(never)
public func run_SetIntersect(N: Int) {
  let size = 400

  SRand()

  var set = Set<Int>(minimumCapacity: size)
  var otherSet = Set<Int>(minimumCapacity: size)

  for _ in 0 ..< size {
    set.insert(Int(truncatingBitPattern: Random()))
    otherSet.insert(Int(truncatingBitPattern: Random()))
  }

  var and = Set<Int>()
  for _ in 0 ..< N * 100 {
    and = set.intersect(otherSet)
  }
  sink(&and)
}
