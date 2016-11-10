//
//  ContactResult.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/10/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import class RealmSwift.Results

public class ContactResult {
    @nonobjc public internal(set) var results: Results<Contact>?
    internal let realm: RealmResult<Contact>
    internal let db = DatabaseManager.sharedInstance
    public init(predicate: NSPredicate?, sort: String, ascending: Bool, closure: ResultChangeClosure?) {
        realm = RealmResult(predicate: predicate, sort: sort, ascending: ascending, closure: closure)
    }
    public func start() {
        guard let results = db.retrieveContacts() else { return }
        self.results = realm.start(filtered(results))
    }
    public func stop() {
        realm.stop()
    }
    fileprivate func filtered(_ results: Results<Contact>) -> Results<Contact> {
        return results.filter("ANY contactTypes.type = %@ OR (ANY contactTypes.type = %@ AND ANY contactTypes.secondaryName = %@)",
                              ContactType.TypeEnum.primary.rawValue,
                              ContactType.TypeEnum.secondary.rawValue, kDefaultSecondaryName)
    }
}
