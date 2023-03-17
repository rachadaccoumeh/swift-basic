//
//  ContentView.swift
//  swiftui
//
//  Created by Telepaty 4 on 16/03/2023.
//

import SwiftUI

struct ContactCell: View {
    let contactName:String
    var imageUrl:URL?
    let hasViva:Bool
    let saved:Bool
    let save:()->Void
    let sendAction:()->Void
    

    
    
    
    var body: some View  {
        let buttonText = hasViva ? "Send Message":"Invite To VIVA"
        VStack{
            HStack{
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 45))
                        .foregroundColor(.accentColor)
                        .imageScale(.large)
                }

                Text(contactName).id("contactName")
            }
            Divider().background(Color.blue)
                .frame(width: 250)
            HStack{
                if !saved {
                    Button("Save Contact", action: save)
                        .foregroundColor(Color.green)
                    Divider().background(Color.blue)
                        .frame(height: 30)
                }
                
                Button(buttonText, action: sendAction)
                
            }.frame(width: .infinity)
        }.padding().background(Color.gray).cornerRadius(25)
    }
}
func saving(){
    print("saving")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContactCell(contactName: "contact name",imageUrl: URL(string: ""), hasViva: true,saved: true) {
            print("saving")
        } sendAction: {
            print("sending")
        }
    }
}
