//
//  SettingsView.swift
//  TrainingTest
//
//  Created by Leonardo Mendez on 6/11/23.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var setDefault: Default
    @State private var isSheetPresented = false
    @State var currencyName = String()
    @State var securityName = String()
    @State var name = String()
    @State var email = String()
    
    var body: some View {
        NavigationStack(path: $store.settings) {
            VStack {
                HStack(spacing: 19) {
                    Image("avatar-2")
                        .frame(width: 80, height: 80)
                    DataProfileView(email: $email, name: $name)
                        .onAppear {
                            email = "irina@mail.com"
                            name = "Irina Saliha"
                        }
                    Spacer()
                    Button(action: {
                    }) {
                        Image("edit-profile-button")
                    }
                }
                VStack(spacing: 47) {
                    VStack(spacing: 20) {
                        SettingsOptionsButton(action: {
                            store.settings.append("currency")
                        }, OptionName: "Currency", name: $currencyName)
                        SettingsOptionsButton(action: {
                            store.settings.append("security")
                        }, OptionName: "Security", name: $securityName)
                    }
                    .onAppear {
                        currencyName = Default.currency()
                        securityName = Default.security()
                    }
                    Button(action: {
                        isSheetPresented.toggle()
                    }, label: {
                        Text("Log out")
                            .foregroundColor(Color("dark-75"))
                    })
                    .sheet(isPresented: $isSheetPresented) {
                        LogoutView(isSheetPresented: isSheetPresented)
                            .presentationDetents([.fraction(0.25)])
                    }
                }
                .padding(.top, 45)
                Spacer()
            }
            .navigationDestination(for: String.self, destination: { route in
                switch route {
                case "currency":
                    CurrencyView()
                case "security":
                    CreateAccountView()
                default:
                    EmptyView()
                }
            })
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "logout"))) { _ in
                setDefault.session = false
            }
        }
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(Store())
        .environmentObject(Default(onboarding: true, session: true))
}