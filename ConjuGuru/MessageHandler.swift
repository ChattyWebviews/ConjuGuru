//
//  MessageHandler.swift
//  ConjuGuru
//
//  Created by Teodor Dermendzhiev on 25.04.23.
//

import Foundation
import ChattyWebviews

class MessageHandler: CWMessageDelegate {
    let verbsDataStore = VerbsDataStore()
    func controller(_ controller: CWViewController, didReceive message: ChattyWebviews.CWMessage) {
        let pageSize = 50
        var page = 0
        if message.topic == "get-verbs" {
            
            if let p = message.body?["page"] as? Int {
                page = p
            }
            
            let verbs = verbsDataStore.getVerbs(offset: page * pageSize, term: message.body?["term"] as? String)
            let msg = VerbsResult(verbs: verbs, page: page)
            try? controller.sendMessage(CWMessage(topic: "update-verbs", body: msg.toDictionary() as NSDictionary))
            
        }
    }
}
