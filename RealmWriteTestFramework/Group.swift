//
//  Group.swift
//  RealmWriteTestApp
//
//  Created by Paul Uhn on 11/8/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation
import RealmSwift

public class Group: Object {
    dynamic var id = ""
    dynamic var uri = ""
    dynamic var name = ""
    @nonobjc internal let groupTypes = List<ContactType>()
    override public static func primaryKey() -> String? { return "id" }
    convenience init(id: String, uri: String, name: String) {
        self.init()
        self.id = id
        self.uri = uri
        self.name = name
    }
}
