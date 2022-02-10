//
//  StorageManager.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 10.02.2022.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    private var tasks: Results<TaskRealm>!
    
    // swiftlint:disable:next force_try
    private let realm = try! Realm()
    
    private init() {}
    
    func fetchTasks(completion: @escaping (_ tasks: Results<TaskRealm>) -> Void) {
        tasks = realm.objects(TaskRealm.self)
        completion(tasks)
    }
}
