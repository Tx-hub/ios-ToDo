//
//  ContentView.swift
//  toDoList
//
//  Created by tuxiao on 2021/2/16.
//

import SwiftUI

var formatter = DateFormatter()
func initUserData() -> [SingToDo]{
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var output: [SingToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "ToDoList") as? Data {
        
            let data = try! decoder.decode([SingToDo].self, from: dataStored)
        for item in data{
            if !item.deleted {
                output.append(SingToDo(title: item.title, duedate: item.duedate, isChecked: item.isChecked, id: output.count))
            }
    }
        
    }
    return output
}

struct ContentView: View {
    @ObservedObject var userData:ToDo = ToDo(data:initUserData())
    
    @State var showEditingPage = false
    
    @State var editingMode = false
    
    
    @State var selection: [Int] = []
    var body: some View {
        ZStack {
            NavigationView{
                ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                    VStack{
                        ForEach(self.userData.ToDoList){item in
                            if !item.deleted{
                                SingleCardView(selection: self.$selection, index: item.id,editingMode: self.$editingMode)
                                    .environmentObject(self.userData)
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .animation(.spring())
                                    .transition(.slide)
                            }
                          
                            
                        }
                       
                     
                    }
                  
            }
                .navigationBarTitle("提醒事项")
                .navigationBarItems(trailing:
                                        HStack {
                                            if self.editingMode{
                                                deleteButton(selection: self.$selection)
                                                    .environmentObject(self.userData)
                                            }
                                            
                                            EditingButton(editingMode: self.$editingMode, selection: self.$selection)
                                        })
          
            }
           
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        if !self.editingMode{
                            self.showEditingPage = true
                        }
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:80)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: self.$showEditingPage,  content: {
                        EditingPage()
                            .environmentObject(self.userData)
                    })
                    
                }
            }
        }
     
       
    }
}
struct deleteButton: View {
    @Binding var selection: [Int]
    @EnvironmentObject var userData: ToDo
    var body: some View{
        Button(action: {
            for i in self.selection {
                self.userData.delete(id: i)
            }
            
        }){
            Image(systemName: "trash")
                .imageScale(.large)
            
        }
    }
}
struct EditingButton: View {
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    var body: some View{
        Button(action: {
            self.editingMode.toggle()
            self.selection.removeAll()
        }){
            Image(systemName: "gear")
                .imageScale(.large)
        }
       
    }
}
struct SingleCardView:View {
    @Binding var selection:[Int]
    @EnvironmentObject var userData: ToDo
    var index: Int
    
    @State  var showEditingPage = false
    @Binding var editingMode:Bool
    
 
    var body: some View {
        HStack{
            Rectangle()
                .frame(width: 6)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            if editingMode{
                Button(action: {
                    self.userData.delete(id: self.index)
                    
                }){
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .padding(.leading)
                    
                        .foregroundColor(.black)
                }
            }
            
          
            Button(
                action: {
                self.showEditingPage = true
                
            }){
                Group{
                    VStack(alignment:.leading,spacing:6){
                        Text( self.userData.ToDoList[index].title)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        
                        Text(formatter.string(from:self.userData.ToDoList[index].duedate) )
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading)
                    Spacer()
                }
                
            }
            .sheet(isPresented: self.$showEditingPage) {
                EditingPage(title: self.userData.ToDoList[self.index].title ,
                            duedate: self.userData.ToDoList[self.index].duedate,
                            id: self.index)
                    .environmentObject(self.userData)
            }
            
            
        
            if !editingMode{
                Image(systemName: self.userData.ToDoList[index].isChecked ?  "checkmark.square.fill":"square")
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture{
                        self.userData.check(id: index)
                    }
            }
            else{
                Image(systemName: self.selection.firstIndex(where:{
                    $0 == self.index
                }) == nil ? "circle" : "checkmark.circle.fill")
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture{
                        if self.selection.firstIndex(where: { $0 == self.index
                        }) == nil{
                            self.selection.append(self.index)
                        }else{
                            self.selection.remove(at: self.selection.firstIndex(where:{
                                $0 == self.index
                            })!)
                        }
                    }
            }
            
           
             
        }
        .frame(height:80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ ,x:0,y:10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userData: ToDo(data: [
                                    SingToDo(title: "写作业", duedate: Date()),
                                             
                                             SingToDo(title: "复习", duedate: Date())
                        
        ]))
    }
}
