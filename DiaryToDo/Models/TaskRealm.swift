//
//  TaskRealm.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 10.02.2022.
//

import RealmSwift

class TaskRealm: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var dateStart = TimeInterval()
    @Persisted var dateFinish = TimeInterval()
    @Persisted var name = ""
    @Persisted var taskDescription = ""
}
