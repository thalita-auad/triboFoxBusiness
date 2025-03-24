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

    var body: some View {
        VStack {
            Text(viewModel.userName ?? "Usuário")
                .font(.title)
                .bold()
                .padding()

            SecureField("Senha", text: $inputPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                isLoggingIn = true
                viewModel.validatePassword(password: inputPassword) {
                    isLoggingIn = false
                }
            }) {
                if isLoggingIn {
                    ProgressView()
                } else {
                    Text("Entrar")
                        .frame(width: 200, height: 50)
                        .background(inputPassword.count >= 6 ? Color.orange : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(inputPassword.count < 6)
            .padding(.top, 20)

            Text(viewModel.errorMessage ?? "")
                .foregroundColor(.red)
                .padding(.top, 10)
        }
        .padding()
    }
}

struct PasswordViewPreviews: PreviewProvider {
    static var viewModel = LoginViewModel()
    static var previews: some View {
        PasswordView(viewModel: viewModel)
    }
}
