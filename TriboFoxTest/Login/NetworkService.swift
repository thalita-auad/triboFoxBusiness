//
//  NetworkService.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 17/03/25.
//

//
//  NetworkService.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 17/03/25.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    private let ambiente = "dev" // Altere para "prod" quando necessário
    private var baseURL: String {
        return "https://autenticacao.\(ambiente).tribofox.com.br/v1"
    }
    
    private var deviceToken: String?
    private var userToken: String?
    
    // MARK: - Requisição Genérica POST
    func postRequest<T: Codable>(
        endpoint: String,
        body: [String: Any],
        token: String? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "URL inválida", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        request.setValue("false", forHTTPHeaderField: "tfx-tokendebug")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        print("🔵 [Request] POST \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Resposta inválida", code: 500, userInfo: nil)))
                return
            }
            
            print("🟢 [Resposta] Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Sem resposta do servidor", code: 500, userInfo: nil)))
                return
            }

            do {
                let responseString = String(data: data, encoding: .utf8) ?? "Resposta inválida"
                print("📩 [Resposta JSON] \(responseString)")

                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("❌ [Erro ao decodificar JSON] \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Login Dispositivo
    func loginDispositivo(completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        let body: [String: Any] = [
            "hash": "Teste0",
            "midia": 6,
            "info": [
                "appVersion": "1.0.0.0",
                "appName": "FoxBusiness Mobile iOS"
            ]
        ]
        
        postRequest(endpoint: "/login/dispositivo", body: body) { (result: Result<TokenResponse, Error>) in
            switch result {
            case .success(let response):
                self.deviceToken = response.token.tokenId
            case .failure(let error):
                print("❌ Erro no login do dispositivo: \(error.localizedDescription)")
            }
            completion(result)
        }
    }
    
    // MARK: - Login Usuário
    func loginUsuario(cpf: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let token = deviceToken else {
            completion(.failure(NSError(domain: "Token do dispositivo não encontrado", code: 401, userInfo: nil)))
            return
        }
        
        let body: [String: Any] = [
            "textoProcurado": cpf,
            "midia": 6,
            "info": [
                "appVersion": "1.0.0.0",
                "appName": "FoxBusiness Mobile iOS"
            ]
        ]
        
        postRequest(endpoint: "/login", body: body, token: token) { (result: Result<TokenResponse, Error>) in
            switch result {
            case .success(let response):
                self.userToken = response.token.tokenId
            case .failure(let error):
                print("❌ Erro no login do usuário: \(error.localizedDescription)")
            }
            completion(result)
        }
    }

    // MARK: - Autenticação de Senha
    func autenticarSenha(senha: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let token = userToken else {
            completion(.failure(NSError(domain: "Token de usuário não encontrado", code: 401, userInfo: nil)))
            return
        }

        let body: [String: Any] = ["senha": "plaintext:\(senha)"]

        postRequest(endpoint: "/login/auth", body: body, token: token) { (result: Result<TokenResponse, Error>) in
            completion(result)
        }
    }

    // MARK: - Buscar Empresas do Usuário
    func buscarEmpresas(completion: @escaping (Result<[Empresa], Error>) -> Void) {
        guard let token = userToken else {
            completion(.failure(NSError(domain: "Token de usuário não encontrado", code: 401, userInfo: nil)))
            return
        }

        let endpoint = "/usuario/empresas?paginacaoInicio=0&paginacaoQuantidadeRetorno=20"
        postRequest(endpoint: endpoint, body: [:], token: token) { (result: Result<[Empresa], Error>) in
            completion(result)
        }
    }
}
