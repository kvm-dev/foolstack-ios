//
//  PrintDebug.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 30.12.2023.
//

/// prints to console only in DEBUG mode
public func printToConsole(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  #if DEBUG
  print(items, separator: separator, terminator: terminator)
  #endif
}
