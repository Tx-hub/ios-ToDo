//
//  ContentView.swift
//  toDoList
//
//  Created by tuxiao on 2021/2/16.
//

import SwiftUI
func initUserData() -> [SingToDo]{
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
    var body: some View {
        ZStack {
            NavigationView{
                ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                    VStack{
                        ForEach(self.userData.ToDoList){item in
                            if !item.deleted{
                                SingleCardView(index: item.id)
                                    .environmentObject(self.userData)
                                    .padding(.top)
                                    .padding(.horizontal)
                            }
                          
                            
                        }
                       
                     
                    }
                  
            }
                .navigationBarTitle("提醒事项")
          
            }
           
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        self.showEditingPage = true
                        
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
struct SingleCardView:View {

    @EnvironmentObject var userData: ToDo
    var index: Int
    
    @State  var showEditingPage = false
 
    var body: some View {
        HStack{
            Rectangle()
                .frame(width: 6)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                self.userData.delete(id: self.index)
                
            }){
                Image(systemName: "trash")
                    .imageScale(.large)
                    .padding(.leading)
                
                    .foregroundColor(.black)
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
                        
                        Text(self.userData.ToDoList[index].duedate.description)
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
            
            
        
            
            Image(systemName: self.userData.ToDoList[index].isChecked ?  "checkmark.square.fill":"square")
                .imageScale(.large)
                .padding(.trailing)
                .onTapGesture{
                    self.userData.check(id: index)
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
        ContentView()
    }
}
