//
//  CreateAccountView.swift
//  TrainingTest
//
//  Created by Leonardo Mendez on 31/10/23.
//

import SwiftUI

struct CreateAccountView: View {
    
    @EnvironmentObject var store: Store
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var birthday: String = ""
    @State private var password: String = ""
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("arrow-left")
                    .foregroundColor(.dark25)
            }
        }
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 56) {
            VStack(spacing: 64) {
                VStack(spacing: 14) {
                    CustomTextField(text: name, placeholder: "Name")
                    CustomTextField(text: email, placeholder: "Email")
                    CustomDateTextField(placeholder: "Birthday")
                    CustomPasswordTextField(password: password, placeholder: "Password")
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            .padding(.top, 64)
            VStack(spacing: 16) {
                CustomButton(action: {
                    
                }, text: "Sing up", color: .violet100, foregroundColor: .white)
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("Create Account")
    }
}

#Preview {
    CreateAccountView()
}
