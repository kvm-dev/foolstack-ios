//
//  URL+Ext.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 30.12.2023.
//

import Foundation

extension URL {
  static func appSupportURL(subfolders: String? = nil) -> URL? {
    guard let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
      return nil
    }
    checkAndCreateDirectory(at: appSupportDir, withIntermediateDirectories: false)
    if let subfolders = subfolders {
      checkAndCreateDirectory(at: appSupportDir.appendingPathComponent(subfolders), withIntermediateDirectories: true)
    }
    return appSupportDir
  }
  
  static func cacheURL(subfolders: String? = nil) -> URL? {
    guard let appSupportDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return nil
    }
    checkAndCreateDirectory(at: appSupportDir, withIntermediateDirectories: false)
    if let subfolders = subfolders {
      checkAndCreateDirectory(at: appSupportDir.appendingPathComponent(subfolders), withIntermediateDirectories: true)
    }
    return appSupportDir.appendingPathComponent(subfolders ?? "")
  }
  
  fileprivate static func checkAndCreateDirectory(at path: URL, withIntermediateDirectories: Bool) {
    let fm = FileManager.default
    if !fm.fileExists(atPath: path.relativePath) {
      do {
        try fm.createDirectory(atPath: path.relativePath,
                               withIntermediateDirectories: withIntermediateDirectories,
                               attributes: nil)
      } catch {
        print(error)
      }
    }
  }

  mutating func skipCloudBackup() {
    let fm = FileManager.default
    if fm.fileExists(atPath: self.path) {
      var rv = URLResourceValues()
      rv.isExcludedFromBackup = true
      do {
        try self.setResourceValues(rv)
      } catch {
        print("Failed skip iCloud backup to URL: \(error.localizedDescription)")
      }
    }
  }
}
