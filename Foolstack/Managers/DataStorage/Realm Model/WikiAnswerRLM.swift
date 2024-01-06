//
//  WikiAnswerRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import RealmSwift

class WikiAnswerRLM: EmbeddedObject {
    @Persisted var content: String = ""

    convenience init(content: String) {
        self.init()
        self.content = content
    }
}
