//
//  PasswordView.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 14/03/25.
//

import SwiftUI

struct PasswordView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var inputPassword: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var isInvalidPassword: Bool = false
    @FocusState private var isPasswordFocused: Bool

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("FoxBusiness")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.orange)
                    .padding()
                
                Text(viewModel.userName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                SecureField("Senha", text: $inputPassword)
                    .padding()
                    .colorScheme(.dark)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isInvalidPassword ? Color.red : (isPasswordFocused ? Color.orange : (Color.gray.opacity(0.3))), lineWidth: 2)
                    )
                    .focused($isPasswordFocused)
                    .onTapGesture {
                        isInvalidPassword = false
                    }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.showPasswordView = false
                        viewModel.showCPFView = true
                    }) {
                        HStack {
                            Text("Voltar")
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.black)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                    }

                    Button(action: {
                        isLoggingIn = true
                        viewModel.validatePassword(password: inputPassword) { isSuccess, errorMessage in
                            if !isSuccess {
                                isInvalidPassword = true
                            }
                            isLoggingIn = false
                        }
                    }) {
                        if isLoggingIn {
                            ProgressView()
                        } else {
                            Text("Logar")
                                .frame(width: 150, height: 50)
                                .background(isValidSize() ? Color.orange : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    .disabled(!isValidSize())
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }

    func isValidSize() -> Bool {
        return inputPassword.count >= 6
    }
}

// MARK: Preview

struct PasswordViewPreviews: PreviewProvider {
    static var viewModel = LoginViewModel()
    static var previews: some View {
        PasswordView(viewModel: viewModel)
    }
}
