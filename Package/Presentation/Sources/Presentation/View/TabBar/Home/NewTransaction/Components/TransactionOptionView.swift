//
//  TransactionOptionView.swift
//  TrainingTest
//
//  Created by Leonardo Mendez on 2/11/23.
//

import SwiftUI
import Domain
import Shared
import Combine

struct TransactionOptionView: View {
    
    var balance: String
    @State var isIncome: Bool
    @State var description = String()
    @State var selectedCategory: CategoryName = .shopping
    @State var selectedPayment = "Wallet"
    @State private var showAlert = false
    @State private var titleAlert: String = ""
    @State private var textAlert: String = ""
    @State private var isSwitchOn = false
    @Binding var value: String
    @Binding var showCustomAlert: Bool
    @StateObject var viewModel: NewTransactionViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            CategorySelectorView(selectedCategory: $selectedCategory)
            CustomTextField(text: $description, placeholder: "Description")
            PayMethodSelectorView(selectedPayment: $selectedPayment)
            if let image = viewModel.image {
                HStack {
                    ZStack {
                        CustomImageView(action: {
                            viewModel.image = nil
                        }, image: image)
                    }
                    Spacer()
                }
            } else {
                Image("add-attachment", bundle: .module)
                    .onTapGesture {
                        viewModel.showActionSheet()
                    }
                    .frame(maxWidth: .infinity)
                    .actionSheet(isPresented: $viewModel.isActionSheetPresented) {
                        ActionSheet(title: Text("Choose Source"), buttons: [
                            .default(Text("Photo Library")) {
                                viewModel.source = .library
                                viewModel.showPhotoPicker()
                            },
                            .default(Text("Camera")) {
                                viewModel.source = .camera
                                viewModel.showPhotoPicker()
                            },
                            .cancel()
                        ])
                    }
            }
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reminder")
                        .textModifierStyle(size: 16, color: Color(.dark25), weight: .semibold)
                    Text("Set a transaction reminder")
                        .textModifierStyle(size: 13, color: Color(.light20), weight: .semibold)
                }
                Spacer()
                Toggle("", isOn: $isSwitchOn)
                    .toggleStyle(SwitchToggleStyle(tint: Color(.violet100)))
            }
            Spacer()
            CustomButton(action: {
                print("value: \(value) balance: \(balance)")
                titleAlert = "Alert!"
                if (!isIncome && ((Double(value) ?? 0) > Double(balance) ?? 0)) {
                    textAlert = "The value cannot be greater than the balance."
                    showAlert.toggle()
                } else if self.value != "0" && !self.value.isEmpty {
                    createTransaction()
                } else {
                    textAlert = "The value should not be 0."
                    showAlert.toggle()
                }
            }, text: "Continue", color: Color(.violet100), foregroundColor: .white)
            Spacer()
                .sheet(isPresented: $viewModel.showPicker, content: {
                    ImagePicker(sourceType: viewModel.source == .library
                                ? .photoLibrary : .camera, selectedImage: $viewModel.image)
                    .ignoresSafeArea()
                })
        }
        .onChange(of: viewModel.image) { _ in
            print("change image")
        }
        .onChange(of: viewModel.success) { newValue in
            if newValue {
                showCustomAlert.toggle()
                viewModel.success = false
            }
        }
        .onAppear {
            viewModel.image = nil
//            viewModel.balance = Int(balance) ?? 0
//            viewModel.generateRandomTransactionsForCurrentMonth()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .topRoundedCorners(cornerRadius: 32, backgroundColor: .white)
    }
    
    func createTransaction() {
        let email = Default.user()?.email ?? ""
        let image = viewModel.image?.toBase64() ?? ""
        Task {
            await viewModel.createTransaction(email: email, 
                                              category: selectedCategory,
                                              description: description,
                                              payment: selectedPayment,
                                              value: value,
                                              isIncome: isIncome,
                                              image: image, 
                                              balance: balance, 
                                              date: Date())
        }
    }
    
}

#Preview {
    TransactionOptionView(balance: "", 
                          isIncome: true,
                          value: .constant("0"),
                          showCustomAlert: .constant(true), 
                          viewModel: Constants.newTransactionViewModel)
}
