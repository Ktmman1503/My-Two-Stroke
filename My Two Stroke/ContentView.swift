//
//  ContentView.swift
//  My Two Stroke
//
//  Created by Craig  Karen Shine on 23/1/20.
//  Copyright © 2020 Craig  Karen Shine. All rights reserved.


import SwiftUI

struct ContentView: View {
  
  
  @State var EngineName : String = ""
  @State var ratioAdd : String = ""
  @State var commentAdd : String = ""
  
  @State var value1 : String = "Value1"
  
  @State private var showActionSheet: Bool = false
  
  @State private var showHelpSheet: Bool = false
  @State private var helpSheetTitle = ""
  @State private var helpSheetMessage = ""
  
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(entity: Stuff.entity(), sortDescriptors: []) var entry: FetchedResults<Stuff>
  
  var body: some View {
    NavigationView {
      VStack(alignment: .center){
       
        Image("my-two-stroke-white")
          .resizable()
          .frame(width: 40.0, height: 40.0)
          .padding(.top, -38)
          .shadow(radius: 05)
        
        ZStack(alignment: .trailing){
          Rectangle()
            .frame(height: 35.0)
            .background(Color.orange)
            .foregroundColor(.orange)
            .padding(.top , 50)
            .shadow(radius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
            .blur(radius: 0.5)

        }.padding(.top, -5)
        
        HStack(alignment: .center) {
          Text("Engine:")
            .font(.custom("Arial Rounded MT Bold", size: 22))
            .fontWeight(.bold)
            .padding(.leading, 15)
          
          Button(action:{self.showHelpSheet = true
            self.helpSheetTitle = "Help"
            self.helpSheetMessage = "Enter the name of your Two Stroke Engine.\rExample : Stihl Chain Saw 251."
          }) {
            Image(systemName : "questionmark.circle.fill")
              .resizable()
              .frame(width: 20.0, height: 20.0)
              .accentColor(.orange)
          }
          Spacer()
          
          TextField("Chainsaw", text: self.$EngineName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
          Button(action: {
            self.saveToCoreData()
            
          }) {
            Image(systemName : "plus.circle.fill")
              .resizable()
              .frame(width: 40.0, height: 40.0)
              .padding(.trailing, 2)
              .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          }
        }.padding(.top ,6)
        
        HStack(alignment: .center) {
          Text("Mix Ratio:")
            .font(.custom("Arial Rounded MT Bold", size: 22))
            .fontWeight(.bold)
            .padding(.leading, 15)
          Button(action:{self.showHelpSheet = true
            self.helpSheetTitle = "Help"
            self.helpSheetMessage = "Enter a number value of the oil to fuel mix ratio recommened by the engine manufacturer. \rExample: 35 or 40 or 50.. it will be shown as 35:1 or 40:1 etc."
          }) {
            Image(systemName : "questionmark.circle.fill")
              .resizable()
              .frame(width: 20.0, height: 20.0)
              .accentColor(.orange)
          }
          
          TextField("50", text: self.$ratioAdd)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 50.0)
            .keyboardType(.numberPad)
          Text(":1")
            .foregroundColor(Color.gray)
          Spacer()
        }.padding(.top ,-10)
        
        
        VStack {
          HStack(alignment: .center) {
            Text("Comment:")
              .font(.custom("Arial Rounded MT Bold", size: 22))
              .fontWeight(.bold)
              .padding(.leading, 15)
            
            Button(action:{self.showHelpSheet = true
              self.helpSheetTitle = "Help"
              self.helpSheetMessage = "This is optional.. A simple short comment."
            }) {
              Image(systemName : "questionmark.circle.fill")
                .resizable()
                .frame(width: 20.0, height: 20.0)
                .accentColor(.orange)
            }
            Spacer()
          }.padding(.top ,-3)
          
          TextField("Comment", text: self.$commentAdd)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.top, -10)
            .padding(.leading ,15)
            .padding(.trailing, 15)
        }
        Divider()
          .padding(.bottom, 10)
        
        List {
          ForEach(entry, id: \.id) { entry in
            NavigationLink(destination: Text(entry.name!)){
            
              VStack(alignment: .leading){
                HStack{
                  Image("my-two-stroke-white")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                  Text(entry.name ?? "Unknown")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                }
                HStack(alignment: .center){
                  Text(entry.ratio ?? "Unknown")
                    .foregroundColor(Color.purple)
                  Text("Mix Ratio")
                    .foregroundColor(Color.purple)
                }
                Text(entry.comment ?? "Unknown")
                  .foregroundColor(Color.gray)
                  .lineLimit(3)
              }
              
            }
            .padding(.top, 15.0)
            
          }
          .onDelete(perform: removeEntry)
          
        }.padding(.top ,-10)

        
      }
      .padding(.top ,-50)
        
      .actionSheet(isPresented: $showActionSheet) {
        ActionSheet( title: Text("WHOOPS!"),message: Text("To store an entry, please input the Name of the Two Stroke Engine and Mix Ratio.\rComment is optional."),
                     buttons: [
                      .default(Text("Ok")),
          ]
        )
        
      }
        
      .alert(isPresented: $showHelpSheet) {
        Alert(title: Text(self.helpSheetTitle), message: Text(self.helpSheetMessage), dismissButton: .default(Text("Got it!")))
      }
        
        
      .navigationBarTitle(Text("My Two Stroke"))
      .navigationBarItems(trailing: EditButton())

    }.padding(.top, 0.0)
    
  }
  
  //Save to Core Data Code
  func saveToCoreData(){
    
    if self.EngineName == "" {
      self.showActionSheet = true
      return
    }
    
    if self.ratioAdd == "" {
      self.showActionSheet = true
      return
    }
    
    //Save values to Core Data
    let entry = Stuff(context: self.moc)
    entry.id = UUID()
    entry.name = "\(self.EngineName)"
    entry.ratio = "\(self.ratioAdd + " : 1")"
    entry.comment = "\(self.commentAdd)"
    self.EngineName = ""
    self.ratioAdd = ""
    self.commentAdd = ""
    try? self.moc.save()
    
    //Clear Fields
    self.helpSheetTitle = "Saved"
    self.helpSheetMessage = "Entry Saved!"
    self.showHelpSheet =  true
    
    
    // Using Extention for dismissing keyboard after save
    self.endEditing()
    
    
  }
  
  // Remove data from Core Data
  
  func removeEntry(at offsets: IndexSet){
    for index in offsets {
      let value = entry[index]
      moc.delete(value)
      do {
        try moc.save()
        
      }
      catch {
        self.showHelpSheet = true
        self.helpSheetTitle = "Error"
        self.helpSheetMessage = "Unable to store your data."
      }
    }
  }
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif

// Extention for dismissing keyboard
extension View {
  func endEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
  }
}

// NavigationLink(destination: Text("Details\r\rEngine:\r\(entry.name!) \rRatio:\(entry.ratio!)\rComment:\r\(entry.comment!)").font(.title).padding(.top ,-300)) {
