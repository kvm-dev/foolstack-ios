//
//  IconNames.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit

enum IconNames {
  case none
  case close
  case back
  case help
  case sort
  case plus
  case delete
  case tag
  case menu
  case checkbox
  case checkboxActive
  case checkboxAll
  case radiobox
  case radioboxActive


  var name: String {
    switch self {
    case .none:           return ""
    case .close:          return "exit.1"
    case .back:           return "arrow.left.1"
    case .help:           return "help.1"
    case .sort:           return "sort.1"
    case .plus:           return "plus.1"
    case .delete:         return "delete.1"
    case .tag:            return "tag.1"
    case .menu:           return "menu.1"
    case .checkbox:       return "check.2"
    case .checkboxActive: return "check.active.1"
    case .checkboxAll:    return "check.all.1"
    case .radiobox:       return "check.2"
    case .radioboxActive: return "check.active.2"

    }
  }
  
/*  var color: UIColor {
    switch self {
    case .help:
      return .themeSpecialIcon
    case .checkbox:
      return .themeDragLine
    case .checkboxActive, .eyeActive:
      return .themeSpecialIcon
    case .radiobox:
      return .themeDragLine
    case .radioboxActive:
      return .themeSpecialIcon
    default:
      return .themeStandartIcon
    }
  }
  
  var colorActive: UIColor {
    switch self {
    case .favorite:
      return .themeFavoriteIcon
    case .learned:
      return .themeSpecialIcon
    default:
      return color
    }
  }
  
  static func checkboxIcon(checked: Bool) -> IconNames {
    return checked ? .checkboxActive : .checkbox
  }

  static func radioboxIcon(checked: Bool) -> IconNames {
    return checked ? .radioboxActive : .radiobox
  }
*/
}
