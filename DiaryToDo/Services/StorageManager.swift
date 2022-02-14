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
    
    func fetchTasks() -> Results<TaskRealm> {
        realm.objects(TaskRealm.self)
    }
    
    func save(_ task: TaskRealm) -> Bool {
        let success = write {
            realm.add(task)
        }
        
        return success
    }
    
    private func write(completion: () -> Void) -> Bool {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
            return false
        }
        
        return true
    }
}
