//
//  SettingsView.swift
//  TrainingTest
//
//  Created by Leonardo Mendez on 6/11/23.
//

import SwiftUI
import Domain
import Shared

struct SettingsView: View {
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var setDefault: DefaultSession
    @State private var isSheetPresented = false
    @State var currencyName: AbbreviationCurrency = .usd
    @State var securityName: SecurityName = .neither
    @State var name = String()
    @State var email = String()
    @State var image = UIImage()
    @State var isLogout: Bool = false
    
    var body: some View {
        NavigationStack(path: $store.settings) {
            VStack {
                HStack(spacing: 19) {
                    CircularImageView(image: image)
                    DataProfileView(email: $email, name: $name)
                    Spacer()
                    EditProfileButton(action: {
                        store.settings.append("editProfile")
                    }, withoutRounding: false, height: 40, width: 40, offsetX: 0.0, offsetY: 0.0)
                }
                VStack(spacing: 47) {
                    VStack(spacing: 20) {
                        SettingsOptionsButton(OptionName: "Currency", name: currencyName.rawValue)
                            .onTapGesture {
                                store.settings.append("currency")
                            }
                        SettingsOptionsButton(OptionName: "Security", name: securityName.rawValue)
                            .onTapGesture {
                                store.settings.append("security")
                            }
                    }
                    .onAppear {
                        currencyName = Default.currency().abbreviation
                        guard let security = Default.security else {
                            self.securityName = .neither
                            return
                        }
                        self.securityName = security.name
                    }
                    Button(action: {
                        isSheetPresented.toggle()
                    }, label: {
                        Text("Log out")
                            .foregroundColor(Color(.dark75))
                    })
                    .sheet(isPresented: $isSheetPresented) {
                        ConfirmationView(isSheetPresented: isSheetPresented,
                                         title: "Log out",
                                         bodyText: "Are you sure you want to log out?",
                                         activeAction: $isLogout)
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
                    SecurityView()
                case "editProfile":
                    EditProfileView(viewModel: Constants.editProfileViewModel)
                default:
                    EmptyView()
                }
            })
            .onAppear {
                email = Default.user()?.email ?? ""
                name = Default.user()?.name ?? ""
                if let imageBase64 = Default.user()?.imageProfile {
                    if !imageBase64.isEmpty {
                        self.image = UIImage.fromBase64(imageBase64) ?? UIImage()
                    } else {
                       self.image = UIImage(named: "empty-user", in: .module, with: nil) ?? UIImage()
                    }
                }
            }
            .onChange(of: isLogout) { _ in
                setDefault.session = false
                Default.destroySession()
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(Store())
        .environmentObject(Default())
}
