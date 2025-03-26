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
        Color.black
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $viewModel.showCPFView) {
                CPFView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.showPasswordView) {
                PasswordView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.showCompaniesView) {
                ListCompaniesView(viewModel: CompanyViewModel(authToken: viewModel.authToken ?? ""))
            }
            .onAppear {
                viewModel.loginDispositivo()
                viewModel.showCPFView = true
            }
    }
}

struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
