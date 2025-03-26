//
//  LoginViewModel.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 13/03/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var cpf: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var errorMessage: String? = nil
    @Published var authToken: String? = nil
    @Published var showCPFView: Bool = false
    @Published var showPasswordView: Bool = false
    @Published var showCompaniesView: Bool = false
    @Published var isInvalidCPF: Bool = false
    
    private var isLoading = false
    
    func loginDispositivo() {
        NetworkService.shared.loginDispositivo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.token.tokenId.isEmpty {
                        self.errorMessage = "Falha ao obter token do dispositivo"
                    } else {
                        self.errorMessage = nil
                        self.showCPFView = true
                    }
                case .failure(let error):
                    self.errorMessage = "Erro ao autenticar dispositivo: \(error.localizedDescription)"
                }
            }
        }
    }

    func validateCPF(completion: @escaping (Bool, String?) -> Void) {
        let body: [String: Any] = [
            "textoProcurado": cpf,
            "midia": 6,
            "info": [
                "appVersion": "1.0.0.0",
                "appName": "FoxBusiness Mobile iOS"
            ]
        ]
        
        NetworkService.shared.loginUsuario(cpf: cpf) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.authToken = response.token.tokenId
                    self.userName = response.usuario?.nome ?? ""
                    self.showPasswordView = true
                    self.showCPFView = false
                    self.errorMessage = nil
                    completion(true, nil)
                    
                case .failure(let error):
                    self.showPasswordView = false
                    self.showCPFView = true
                    completion(false, "CPF inválido")
                    self.isInvalidCPF = true  // Marca como erro
                    print("Erro ao validar CPF: \(error.localizedDescription)")
                }
            }
        }
    }

    func validatePassword(password: String, completion: @escaping () -> Void) {
        guard let token = authToken else {
            errorMessage = "Token de usuário não encontrado"
            completion()
            return
        }
        
        let body: [String: Any] = ["senha": "plaintext:\(password)"]
        
        NetworkService.shared.postRequest(endpoint: "/login/auth", body: body, token: token) { (result: Result<TokenResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.authToken = response.token.tokenId
                    self.errorMessage = nil // Login bem-sucedido
                    self.showCompaniesView = true
                    self.showPasswordView = false
                case .failure:
                    self.errorMessage = "Senha incorreta"
                }
                completion()
            }
        }
    }
}
