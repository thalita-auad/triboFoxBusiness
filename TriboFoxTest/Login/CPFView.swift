//
//  CPFView.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 14/03/25.
//

import SwiftUI

struct CPFView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var inputCPF: String = ""

    var body: some View {
        VStack {
            TextField("CPF", text: $inputCPF)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button(action: {
                viewModel.cpf = inputCPF
                viewModel.validateCPF()
            }) {
                Text("Próximo")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct CPFViewPreviews: PreviewProvider {
    static var viewModel = LoginViewModel()
    static var previews: some View {
        CPFView(viewModel: viewModel) 
    }
}
