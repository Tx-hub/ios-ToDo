//
//  EditingPage.swift
//  toDoList
//
//  Created by tuxiao on 2021/2/16.
//

import SwiftUI

struct EditingPage: View {
    
    @EnvironmentObject var userData: ToDo
    
    @State var title: String = ""
    @State var duedate: Date = Date()
    
    var id: Int? = nil
    
    @Environment(\.presentationMode) var presentation
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("事项")){
                    TextField("事项内容", text: self.$title)
                    DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { Text("截止时间") })
                  
                }
                Section{
                    Button(action: {
                        if self.id == nil {
                            self.userData.add(data: SingToDo(title: self.title, duedate: self.duedate))
                           
                        }
                        else {
                            self.userData.edit(id:self.id!,data: SingToDo(title: self.title, duedate: self.duedate))
                            
                        }
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("确认")
                    }
                    Button(action: {
                
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("取消")
                    }
                   
                  
                }
               
            }
            .navigationBarTitle("添加")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
