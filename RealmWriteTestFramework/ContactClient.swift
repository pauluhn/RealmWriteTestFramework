//
//  ContactClient.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/9/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation

public class ContactClient {
    
    fileprivate let queue = DispatchQueue(label: "ContactClient Queue")
    fileprivate let db = DatabaseManager.sharedInstance
    
    public init() {}

    public func getAllContactsAndGroups(completion: @escaping CompletionBlock) {
        getPrimaryContacts {
            self.getPrimaryGroups {
                self.getSecondaryContacts {
                    self.getSecondaryGroups {
                        completion()
                    }
                }
            }
        }
    }
    
    fileprivate func getPrimaryContacts(completion: @escaping CompletionBlock) {
        let contactTimestamp = ContactTimestamp(type: .primaryContacts)
        let _ = db.retrieveContactTimestamps()?.filter("id = %@", contactTimestamp.id).first?.timestamp
        PrimaryContactsRequest { (response) in
            self.queue.async {
                switch response {
                case .failure(let error):
                    print(error)
                    completion()
                case .success(let data):
                    let (contacts, paging) = ContactBuilder(type: .primary, secondaryName: nil).build(data)
                    self.db.writeObjects(contacts) {
                        self.db.writeContactTimestamp(contactTimestamp) {
                            if paging {
                                self.getPrimaryContacts(completion: completion)
                            } else {
                                completion()
                            }
                        }
                    }
                }
            }
        }.connect()
    }
    
    fileprivate func getPrimaryGroups(completion: @escaping CompletionBlock) {
        let contactTimestamp = ContactTimestamp(type: .primaryGroups)
        let _ = db.retrieveContactTimestamps()?.filter("id = %@", contactTimestamp.id).first?.timestamp
        PrimaryGroupsRequest { (response) in
            self.queue.async {
                switch response {
                case .failure(let error):
                    print(error)
                    completion()
                case .success(let data):
                    let (groups, paging) = GroupBuilder(type: .primary, secondaryName: nil).build(data)
                    self.db.writeObjects(groups) {
                        self.db.writeContactTimestamp(contactTimestamp) {
                            if paging {
                                self.getPrimaryGroups(completion: completion)
                            } else {
                                completion()
                            }
                        }
                    }
                }
            }
        }.connect()
    }
    
    fileprivate func getSecondaryContacts(completion: @escaping CompletionBlock) {
        let contactTimestamp = ContactTimestamp(type: .secondaryContacts)
        let _ = db.retrieveContactTimestamps()?.filter("id = %@", contactTimestamp.id).first?.timestamp
        SecondaryContactsRequest { (response) in
            self.queue.async {
                switch response {
                case .failure(let error):
                    print(error)
                    completion()
                case .success(let data):
                    let (contacts, paging) = ContactBuilder(type: .secondary, secondaryName: kDefaultSecondaryName).build(data)
                    self.db.writeObjects(contacts) {
                        self.db.writeContactTimestamp(contactTimestamp) {
                            if paging {
                                self.getSecondaryContacts(completion: completion)
                            } else {
                                completion()
                            }
                        }
                    }
                }
            }
        }.connect()
    }
    
    fileprivate func getSecondaryGroups(completion: @escaping CompletionBlock) {
        let contactTimestamp = ContactTimestamp(type: .secondaryGroups)
        let _ = db.retrieveContactTimestamps()?.filter("id = %@", contactTimestamp.id).first?.timestamp
        SecondaryGroupsRequest { (response) in
            self.queue.async {
                switch response {
                case .failure(let error):
                    print(error)
                    completion()
                case .success(let data):
                    let (groups, paging) = GroupBuilder(type: .secondary, secondaryName: kDefaultSecondaryName).build(data)
                    self.db.writeObjects(groups) {
                        self.db.writeContactTimestamp(contactTimestamp) {
                            if paging {
                                self.getSecondaryGroups(completion: completion)
                            } else {
                                completion()
                            }
                        }
                    }
                }
            }
        }.connect()
    }
}
