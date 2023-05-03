//
//  VerbsDataStore.swift
//  ConjuGuru
//
//  Created by Teodor Dermendzhiev on 20.03.23.
//

import Foundation
import SQLite

public struct VerbsResult: Codable {
    public let verbs: [Verb]
    public let page: Int
}

public struct Verb: Codable {
    let name: String
    let infinitive: String
    let moods: String
}

public class VerbsDataStore {
    
    private let verbs = Table("verbs")

    private let infinitive = Expression<String>("infinitive")
    private let name = Expression<String>("name")
    private let moods = Expression<String>("moods")
    
    static let shared = VerbsDataStore()
    
    private var db: Connection? = nil
    
    public init() {
        
        do {
            let dbPath = Bundle.main.url(forResource: "verbs", withExtension: "db")!.path
            db = try Connection(dbPath)
            print("SQLiteDataStore init successfully at: \(dbPath)")
        } catch {
            db = nil
            print("SQLiteDataStore init error: \(error)")
        }
    }
    
    func getVerbs(offset: Int, term: String? = nil) -> [Verb] {
        var verbs: [Verb] = []
        guard let database = db else { return [] }

        do {
            var query: QueryType?
            if let term = term {
                query = self.verbs.limit(50, offset: offset).order(name.asc).filter(name.like("%\(term)%"))
            } else {
                query = self.verbs.limit(50, offset: offset).order(name.asc)
            }
            for verb in try database.prepare(query!) {
                verbs.append(Verb(name: verb[name], infinitive: verb[infinitive], moods: verb[moods]))
            }
        } catch {
            print(error)
        }
        return verbs
    }
}
