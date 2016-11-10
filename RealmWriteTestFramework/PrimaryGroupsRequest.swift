//
//  PrimaryGroupsRequest.swift
//  RealmWriteTestApp
//
//  Created by Paul Uhn on 11/8/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation

struct PrimaryGroupsRequest: FakeRequest {
    let type: FakeRequestType = .primaryGroups
    let closure: FakeResponseClosure
    init(closure: @escaping FakeResponseClosure) {
        self.closure = closure
    }
}
