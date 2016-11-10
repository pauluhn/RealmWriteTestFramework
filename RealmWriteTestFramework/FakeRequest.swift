//
//  FakeRequest.swift
//  RealmWriteTestApp
//
//  Created by Paul Uhn on 11/8/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation

enum FakeRequestType {
    case primaryContacts
    case primaryGroups
    case secondaryContacts
    case secondaryGroups
}

enum FakeResponse {
    case success(data: [AnyHashable: Any])
    case failure(error: Error)
}

typealias FakeResponseClosure = (FakeResponse) -> Void

protocol FakeRequest {
    var type: FakeRequestType { get }
    var closure: FakeResponseClosure { get }
    func connect()
}

extension FakeRequest {
    func connect() {
        switch type {
        case .primaryContacts, .secondaryContacts:
            FakeServer.default.contacts(type: type) { (response) in
                switch response {
                case .failure(let error):
                    self.closure(.failure(error: error))
                case .success(let data):
                    self.closure(.success(data: data))
                }
            }
        case .primaryGroups, .secondaryGroups:
            FakeServer.default.groups(type: type) { (response) in
                switch response {
                case .failure(let error):
                    self.closure(.failure(error: error))
                case .success(let data):
                    self.closure(.success(data: data))
                }
            }
        }
    }
}

