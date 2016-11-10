//
//  DatabaseManager.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/9/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import RealmSwift

public typealias CompletionBlock = () -> Void

public class DatabaseManager {
    
    public static let sharedInstance = DatabaseManager()
    
    fileprivate let queue = DispatchQueue(label: "DatabaseManager Queue")
    fileprivate var displayRealm = true

    func getRealm() -> Realm? {
        do {
            let realm = try Realm()
            if displayRealm {
                displayRealm = false
                print("realm is at \(realm.configuration.fileURL)")
            }
            return realm
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func retrieveContactTimestamps() -> Results<ContactTimestamp>? {
        guard let realm = getRealm() else { return nil }
        return realm.objects(ContactTimestamp.self)
    }
    
    public func retrieveContacts() -> Results<Contact>? {
        guard let realm = getRealm() else { return nil }
        return realm.objects(Contact.self)
    }
    
    public func retrieveGroups() -> Results<Group>? {
        guard let realm = getRealm() else { return nil }
        return realm.objects(Group.self)
    }
    
    func writeObjects(_ objects: [Object], completion: @escaping CompletionBlock) {
        guard !objects.isEmpty else { return }
        queue.async {
            guard let realm = self.getRealm() else { return }
            do {
                try realm.write {
                    realm.add(objects, update: true)
                }
            } catch {
                print(error.localizedDescription)
            }
            completion()
        }
    }
    
    func writeContactTimestamp(_ contactTimestamp: ContactTimestamp, completion: @escaping CompletionBlock) {
        let timestamp = contactTimestamp
        timestamp.timestamp = Date().description
        writeObjects([timestamp]) {
            completion()
        }
    }
}
