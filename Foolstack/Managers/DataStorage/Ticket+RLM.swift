//
//  TicketEntity+RLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 09.01.2024.
//

import RealmSwift

extension RealmActor {
    func addTickets(_ data: [TicketData]) async throws -> [TicketEntity] {
        let items = data.map (TicketRLM.init)
        
        let realm = try await getRealm()
        try await realm.asyncWrite {
            realm.add(items, update: .modified)
        }
        
        return convertTicketItemsToEntities(items)
    }
    
    private func getTicketItems(for tags: [ServerKey]) async throws -> [TicketRLM] {
        let realm = try await getRealm()
        let result = realm.objects(TicketRLM.self)
            .where {
                $0.tags.containsAny(in: tags)
            }
        let res = Array(result)
        //        print(res)
        return res
    }
    
    func getTicketEntities(for tags: [ServerKey]) async throws -> [TicketEntity] {
        let items = try await getTicketItems(for: tags)
        return convertTicketItemsToEntities(items)
    }
    
    func convertTicketItemsToEntities(_ items: [TicketRLM]) -> [TicketEntity] {
        items.map { t in
            TicketEntity(
                id: t.serverId,
                name: t.name,
                questions: t.questions.map { q in
                    TicketQuestionEntity(
                        question: q.question,
                        variants: Array(q.variants),
                        answers: Array(q.answers)
                    )
                },
                tags: Array(t.tags)
            )
        }
    }
    
    func deleteTicketItem(id: String) async throws {
        let objid = try ObjectId(string: id)
        let realm = try await getRealm()
        let item = realm.object(ofType: TicketRLM.self, forPrimaryKey: objid)
        if let item = item {
            try await realm.asyncWrite {
                realm.delete(item)
            }
        }
    }

}



