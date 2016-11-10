//
//  FakeServer.swift
//  RealmWriteTestApp
//
//  Created by Paul Uhn on 11/8/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation

enum FakeServerResponse {
    case success(data: [AnyHashable: Any])
    case failure(error: Error)
}

typealias FakeServerResponseClosure = (FakeServerResponse) -> Void

class FakeServer {
    static let `default` = FakeServer()
    var primaryContacts = 100
    var primaryGroups = 1
    var secondaryContacts = 100
    var secondaryGroups = 1
    func contacts(type: FakeRequestType, completion: @escaping FakeServerResponseClosure) {
        var data = [AnyHashable: Any]()
        data["paging"] = paging(type: type)
        var list = [[AnyHashable: Any]]()
        for _ in 0..<100 {
            list.append(["id": NSUUID().uuidString, "name": NSUUID().uuidString])
        }
        data["list"] = list
        completion(.success(data: data))
    }
    func groups(type: FakeRequestType, completion: @escaping FakeServerResponseClosure) {
        var data = [AnyHashable: Any]()
        data["paging"] = paging(type: type)
        var list = [[AnyHashable: Any]]()
        for _ in 0..<100 {
            list.append(["id": NSUUID().uuidString, "uri": NSUUID().uuidString, "name": NSUUID().uuidString])
        }
        data["list"] = list
        completion(.success(data: data))
    }
    fileprivate func paging(type: FakeRequestType) -> Bool {
        switch type {
        case .primaryContacts:
            primaryContacts -= 1
            return primaryContacts > 0
        case .primaryGroups:
            primaryGroups -= 1
            return primaryGroups > 0
        case .secondaryContacts:
            secondaryContacts -= 1
            return secondaryContacts > 0
        case .secondaryGroups:
            secondaryGroups -= 1
            return secondaryGroups > 0
        }
    }
}
