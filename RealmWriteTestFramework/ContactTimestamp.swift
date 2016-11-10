//
//  ContactTimestamp.swift
//  RealmWriteTestApp
//
//  Created by Paul Uhn on 11/8/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import RealmSwift

class ContactTimestamp: Object {
    dynamic var id = ""
    dynamic var timestamp = ""
    dynamic var type: TypeEnum = .primaryContacts
    @objc enum TypeEnum: Int {
        case primaryContacts
        case primaryGroups
        case secondaryContacts
        case secondaryGroups
    }
    override static func primaryKey() -> String? { return "id" }
    convenience init(type: TypeEnum) {
        self.init()
        self.type = type
        self.id = description
    }
    override var description: String {
        get {
            switch type {
            case .primaryContacts:   return "primaryContacts"
            case .primaryGroups:     return "primaryGroups"
            case .secondaryContacts: return "secondaryContacts"
            case .secondaryGroups:   return "secondaryGroups"
            }
        }
    }
}
