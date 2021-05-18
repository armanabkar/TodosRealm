//
//  TodoListViewController.swift
//  TodosRealm
//
//  Created by Arman Abkar on 5/15/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
