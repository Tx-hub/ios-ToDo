//
//  UserData.swift
//  toDoList
//
//  Created by tuxiao on 2021/2/16.
//

import SwiftUI
import UserNotifications

let NotificationContent = UNMutableNotificationContent()
var encoder = JSONEncoder()
var decoder = JSONDecoder()
class ToDo: ObservableObject{
    @Published var ToDoList:[SingToDo]
    var count = 0
    
    init() {
       
        self.ToDoList = []
    }
    
    init(data:[SingToDo]) {
        self.ToDoList = []
        for item in data {
            self.ToDoList.append(SingToDo(title: item.title, duedate: item.duedate, isChecked: item.isChecked,  id: self.count))
            count += 1
        }
    }
    
    func check(id:Int) {
        self.ToDoList[id].isChecked.toggle()
        self.dataStore()
    }
    func add(data: SingToDo) {
 
        self.ToDoList.append(SingToDo(title: data.title, duedate: data.duedate, id: self.count))
        self.sort()
        self.dataStore()
        sendNotificatin(id: self.ToDoList.count-1)
    }
    func edit(id: Int, data: SingToDo)  {
        self.withdrawNotification(id:id)
        self.ToDoList[id].title = data.title
        self.ToDoList[id].duedate = data.duedate
        self.ToDoList[id].isChecked = false
        self.sort()
        self.dataStore()
  
        sendNotificatin(id: id)
    }
    func sendNotificatin(id: Int)  {
        NotificationContent.title = self.ToDoList[id].title
        NotificationContent.sound = UNNotificationSound.default
        if self.ToDoList[id].duedate.timeIntervalSinceNow > 0{
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.ToDoList[id].duedate.timeIntervalSinceNow, repeats: false)
            let request = UNNotificationRequest(identifier: self.ToDoList[id].title+self.ToDoList[id].duedate.description, content: NotificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
       else{
            
                print("timeIntervalSinceNow小于0")
        }
      
       
      
    }
    func withdrawNotification(id:Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.ToDoList[id].title + self.ToDoList[id].duedate.description])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.ToDoList[id].title + self.ToDoList[id].duedate.description])
    }
    func sort() {
        self.ToDoList.sort(by: {(data1,data2) in
            return data1.duedate.timeIntervalSince1970 < data2.duedate.timeIntervalSince1970
        })
        for i in 0..<self.ToDoList.count{
            self.ToDoList[i].id = i
        }
    }
    func delete(id: Int)  {
        self.withdrawNotification(id:id)
        self.ToDoList[id].deleted = true
        self.dataStore()
    }
    func dataStore(){
        let dataStored = try! encoder.encode(self.ToDoList)
        UserDefaults.standard.set(dataStored,forKey: "ToDoList")
    }
}
struct SingToDo: Identifiable,Codable {
    var title: String = ""
    var duedate: Date = Date()
    var isChecked: Bool = false
    var id:Int = 0
    var deleted = false
}
