//
//  ContactBuilder.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/9/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation

struct ContactBuilder {
    let type: ContactType.TypeEnum
    let secondaryName: String?
    let db = DatabaseManager.sharedInstance
    
    func build(_ data: [AnyHashable: Any]) -> ([Contact], Bool) {
        var contacts = [Contact]()
        guard let paging = data["paging"] as? Bool,
            let list = data["list"] as? [[AnyHashable: Any]] else { return (contacts, false) }
        for item in list {
            if let contact = buildContact(item) {
                contacts.append(contact)
            }
        }
        return (contacts, paging)
    }
    
    fileprivate func buildContact( _ data: [AnyHashable: Any]) -> Contact? {
        guard let id = data["id"] as? String,
            let name = data["name"] as? String else { return nil }
        let contact = Contact(id: id, name: name)
        buildContactTypes(contact)
        return contact
    }
    
    fileprivate func buildContactTypes(_ contact: Contact) {
        let predicate = NSPredicate(format: "id = %@", contact.id)
        let contactResult = ContactResult(predicate: predicate, sort: "id", ascending: true, closure: nil)
        contactResult.start()
        guard let first = contactResult.results?.first else {
            contact.contactTypes.append(buildContactType(contact))
            return
        }
        contact.contactTypes.append(objectsIn: first.contactTypes.map { $0.getCopy() })
        let contactType = buildContactType(contact)
        if contact.contactTypes.index(matching: "id == %@", contactType.id) == nil {
            contact.contactTypes.append(contactType)
        }
    }
    
    fileprivate func buildContactType(_ contact: Contact) -> ContactType {
        return ContactType(contactId: contact.id, type: type, secondaryName: secondaryName)
    }
}
