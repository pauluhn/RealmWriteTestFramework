//
//  RealmResult.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/10/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import RealmSwift

public typealias ResultChangeClosure = (_ insertions: [Int], _ modifications: [Int], _ deletions: [Int], _ error: Error?) -> Void

class RealmResult<T: Object> {
    let predicate: NSPredicate?
    let sort: String
    let ascending: Bool
    let closure: ResultChangeClosure?
    var token: NotificationToken?
    init(predicate: NSPredicate?, sort: String, ascending: Bool, closure: ResultChangeClosure?) {
        self.predicate = predicate
        self.sort = sort
        self.ascending = ascending
        self.closure = closure
    }
    deinit {
        stop()
    }
    func start(_ results: Results<T>) -> Results<T> {
        var newResults = results
        if let predicate = predicate {
            newResults = newResults.filter(predicate)
        }
        newResults = newResults.sorted(byProperty: sort, ascending: ascending)
        if let closure = closure {
            token = newResults.addNotificationBlock { (change) in
                switch change {
                case .initial:
                    break
                case let .update(_, deletions: d, insertions: i, modifications: m):
                    closure(i, m, d, nil)
                case .error(let e):
                    closure([], [], [], e)
                }
            }
        }
        return newResults
    }
    func stop() {
        token?.stop()
        token = nil
    }
}
