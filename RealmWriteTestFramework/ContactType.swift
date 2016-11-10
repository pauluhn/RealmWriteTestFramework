//
//  ContactType.swift
//  RealmWriteTestApp
//
//  Created by Paul Uhn on 11/8/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import RealmSwift

let kDefaultSecondaryName = "default secondary name"

class ContactType: Object {
    dynamic var id = ""
    dynamic var contactId = ""
    dynamic var type: TypeEnum = .primary
    dynamic var secondaryName = ""
    @objc enum TypeEnum: Int {
        case primary
        case secondary
    }
    override static func primaryKey() -> String? { return "id" }
    convenience init(contactId: String, type: TypeEnum, secondaryName: String?) {
        self.init()
        self.contactId = contactId
        self.type = type
        self.secondaryName = secondaryName ?? ""
        self.id = description
    }
    override var description: String {
        get {
            switch type {
            case.primary:   return "\(contactId)primary"
            case.secondary: return "\(contactId)secondary\(secondaryName)"
            }
        }
    }
    func getCopy() -> ContactType {
        return ContactType(contactId: contactId, type: type, secondaryName: secondaryName)
    }
}
