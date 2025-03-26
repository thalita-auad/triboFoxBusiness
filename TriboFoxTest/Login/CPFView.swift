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
    @FocusState private var isCPFFocused: Bool
    @State private var isInvalidSizeCPF: Bool = false
    @State private var isInvalidCPF: Bool = false
    @State private var cpfErrorMessage: String? = nil

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
                
                Text("Login")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                
                TextField("CPF", text: $inputCPF)
                    .keyboardType(.numberPad)
                    .colorScheme(.dark)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isInvalidCPF ? Color.red : (isCPFFocused ? Color.orange : (Color.gray.opacity(0.3))), lineWidth: 2)
                    )
                    .focused($isCPFFocused)
                    .onTapGesture {
                        isInvalidCPF = false
                    }
                    .onChange(of: inputCPF) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.count > 11 {
                            inputCPF = String(filtered.prefix(11))
                        } else {
                            inputCPF = filtered
                        }
                        inputCPF = formatCPF(inputCPF)
                        isInvalidSizeCPF = !isValidSizeCPF()
                    }

                if isInvalidSizeCPF && inputCPF.count == 14 {
                    Text("Usuário inválido")
                        .foregroundColor(.red)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    let cleanCPF = removeMask(inputCPF)
                    viewModel.cpf = cleanCPF
                    isInvalidCPF = false
                    viewModel.validateCPF { isSuccess, errorMessage in
                        if !isSuccess {
                            isInvalidCPF = true
                            cpfErrorMessage = errorMessage
                        }
                    }
                }) {
                    Text("Próximo")
                        .frame(width: 200, height: 50)
                        .background(isValidSizeCPF() ? Color.orange : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .disabled(!isValidSizeCPF())

                if isInvalidCPF {
                    Text(cpfErrorMessage ?? "Usuário inválido")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }

    func isValidSizeCPF() -> Bool {
        return inputCPF.count == 14
    }

    func formatCPF(_ cpf: String) -> String {
        let numbers = cpf.filter { $0.isNumber }
        var result = ""
        let mask = "XXX.XXX.XXX-XX"
        var index = numbers.startIndex
        for ch in mask {
            if index == numbers.endIndex { break }
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

    func removeMask(_ cpf: String) -> String {
        return cpf.filter { $0.isNumber }
    }
}

// MARK: Preview
struct CPFViewPreviews: PreviewProvider {
    static var viewModel = LoginViewModel()
    static var previews: some View {
        CPFView(viewModel: viewModel)
    }
}
