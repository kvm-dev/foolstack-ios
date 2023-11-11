//
//  WikiData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

struct WikiData: Codable, Equatable {
  
  // MARK: - Identifier Properties
  let id: String
  
  // MARK: - Instance Properties
  let imageURL: URL?
  let name: String
}
