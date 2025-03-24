//
//  LoginView.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 13/03/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var companyViewModel = CompanyViewModel(authToken: "")

    var body: some View {
        VStack {
            Text("FoxBusiness")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .bold()
                .padding(.bottom, 20)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .bold()
                    .padding(.bottom, 10)
            }

            Button(action: {
                // Chama o dispositivo e valida o CPF
                viewModel.loginDispositivo()
                viewModel.showCPFView = true
            }) {
                Text("Fazer Login")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .fullScreenCover(isPresented: $viewModel.showCPFView) {
            CPFView(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showPasswordView) {
            PasswordView(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showCompaniesView) {
            ListCompaniesView(viewModel: CompanyViewModel(authToken: viewModel.authToken ?? ""))
        }
    }
}

struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
