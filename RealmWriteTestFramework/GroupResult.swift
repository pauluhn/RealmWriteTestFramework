//
//  GroupResult.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/10/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import class RealmSwift.Results

public class GroupResult {
    @nonobjc public internal(set) var results: Results<Group>?
    internal let realm: RealmResult<Group>
    internal let db = DatabaseManager.sharedInstance
    public init(predicate: NSPredicate?, sort: String, ascending: Bool, closure: ResultChangeClosure?) {
        realm = RealmResult(predicate: predicate, sort: sort, ascending: ascending, closure: closure)
    }
    public func start() {
        guard let results = db.retrieveGroups() else { return }
        self.results = realm.start(filtered(results))
    }
    public func stop() {
        realm.stop()
    }
    fileprivate func filtered(_ results: Results<Group>) -> Results<Group> {
        return results.filter("ANY groupTypes.type = %@ OR (ANY groupTypes.type = %@ AND ANY groupTypes.secondaryName = %@)",
                              ContactType.TypeEnum.primary.rawValue,
                              ContactType.TypeEnum.secondary.rawValue, kDefaultSecondaryName)
    }
}
