//
//  GroupBuilder.swift
//  RealmWriteTestFramework
//
//  Created by Paul Uhn on 11/9/16.
//  Copyright © 2016 Paul Uhn. All rights reserved.
//

import Foundation

struct GroupBuilder {
    let type: ContactType.TypeEnum
    let secondaryName: String?
    let db = DatabaseManager.sharedInstance

    func build(_ data: [AnyHashable: Any]) -> ([Group], Bool) {
        var groups = [Group]()
        guard let paging = data["paging"] as? Bool,
            let list = data["list"] as? [[AnyHashable: Any]] else { return (groups, false) }
        for item in list {
            if let group = buildGroup(item) {
                groups.append(group)
            }
        }
        return (groups, paging)
    }
    
    fileprivate func buildGroup(_ data: [AnyHashable: Any]) -> Group? {
        guard let id = data["id"] as? String,
            let uri = data["uri"] as? String,
            let name = data["name"] as? String else { return nil }
        let group = Group(id: id, uri: uri, name: name)
        buildGroupTypes(group)
        return group
    }
    
    fileprivate func buildGroupTypes(_ group: Group) {
        let predicate = NSPredicate(format: "id = %@", group.id)
        let groupResult = GroupResult(predicate: predicate, sort: "id", ascending: true, closure: nil)
        groupResult.start()
        guard let first = groupResult.results?.first else {
            group.groupTypes.append(buildGroupType(group))
            return
        }
        group.groupTypes.append(objectsIn: first.groupTypes.map { $0.getCopy() })
        let groupType = buildGroupType(group)
        if group.groupTypes.index(matching: "id == %@", groupType.id) == nil {
            group.groupTypes.append(groupType)
        }
    }
    
    fileprivate func buildGroupType(_ group: Group) -> ContactType {
        return ContactType(contactId: group.id, type: type, secondaryName: secondaryName)
    }
}
