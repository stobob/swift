//===--- ArgParse.swift ---------------------------------------------------===//
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

import Foundation

public struct Arguments {
  public var progName: String
  public var positionalArgs: [String]
  public var optionalArgsMap: [String : String]

  init(_ pName: String, _ posArgs: [String], _ optArgsMap: [String : String]) {
    progName = pName
    positionalArgs = posArgs
    optionalArgsMap = optArgsMap
  }
}

/// Using Process.arguments, returns an Arguments struct describing
/// the arguments to this program. If we fail to parse arguments, we
/// return .None.
///
/// We assume that optional switch args are of the form:
///
/// --opt-name[=opt-value]
/// -opt-name[=opt-value]
///
/// with opt-name and opt-value not containing any '=' signs. Any
/// other option passed in is assumed to be a positional argument.
public func parseArgs(validOptions: [String]? = .None)
  -> Arguments? {
  let progName = Process.arguments[0]
  var positionalArgs = [String]()
  var optionalArgsMap = [String : String]()

  // For each argument we are passed...
  var passThroughArgs = false
  for arg in Process.arguments[1..<Process.arguments.count] {
    // If the argument doesn't match the optional argument pattern. Add
    // it to the positional argument list and continue...
    if passThroughArgs || !arg.characters.startsWith("-".characters) {
      positionalArgs.append(arg)
      continue
    }
    if arg == "--" {
      passThroughArgs = true
      continue
    }
    // Attempt to split it into two components separated by an equals sign.
    let components = arg.componentsSeparatedByString("=")
    let optionName = components[0]
    if validOptions != nil && !validOptions!.contains(optionName) {
      print("Invalid option: \(arg)")
      return .None
    }
    var optionVal : String
    switch components.count {
      case 1: optionVal = ""
      case 2: optionVal = components[1]
      default:
      // If we do not have two components at this point, we can not have
      // an option switch. This is an invalid argument. Bail!
      print("Invalid option: \(arg)")
      return .None
    }
    optionalArgsMap[optionName] = optionVal
  }

  return .Some(Arguments(progName, positionalArgs, optionalArgsMap))
}
