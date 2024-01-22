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
    case faq
    case faqActive
    case hr
    case hrActive
    case tests
    case testsActive
    case filter
    case apple
    case google
    case email
    
    var name: String {
        switch self {
        case .none:           return ""
        case .close:          return "xmark.app"
        case .back:           return "arrowshape.turn.up.backward"//"arrowshape.turn.up.backward"//"chevron-left"
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
        case .faq:            return "tech_interview"
        case .faqActive:      return "tech_interview.selected"
        case .hr:             return "hr_interview"
        case .hrActive:       return "hr_interview.selected"
        case .tests:          return "tests"
        case .testsActive:    return "tests.selected"
        case .filter:         return "filter.5"
        case .apple:          return "apple.logo"
        case .google:         return "g.circle"
        case .email:          return "at"
        }
    }
    
    var color: UIColor {
        switch self {
        case .checkbox:
            return .themeButtonUnselected
        case .checkboxActive:
            return .themeButtonSelected
        case .radiobox:
            return .themeButtonUnselected
        case .radioboxActive:
            return .themeButtonSelected
        default:
            return .themeStandartIcon
        }
    }
    
    /*  var colorActive: UIColor {
     switch self {
     case .favorite:
     return .themeFavoriteIcon
     case .learned:
     return .themeSpecialIcon
     default:
     return color
     }
     }*/
    
    static func checkboxIcon(checked: Bool) -> IconNames {
        return checked ? .checkboxActive : .checkbox
    }
    
    static func radioboxIcon(checked: Bool) -> IconNames {
        return checked ? .radioboxActive : .radiobox
    }
    
}
