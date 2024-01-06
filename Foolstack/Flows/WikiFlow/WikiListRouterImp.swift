//
//  WikiListRouterImp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation
import UIKit

@MainActor
final class WikiListRouterImp : WikiListRouter {
    weak var viewController: UIViewController?
    
    func openTagList(tags: [TagEntity]) {
//        let vc = TagListVC(tags: tags)
//        viewController?.present(vc, animated: true)
    }
}
