//
//  CompaniesNetworkService.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 19/03/25.
//

import Foundation

struct ErrorResponse: Codable {
    let type: String?
    let title: String?
    let status: Int?
    let detail: String?
    let instance: String?
}

class CompaniesNetworkService {
    static let shared = CompaniesNetworkService()
    private init() {}

    private let ambiente = "dev"
    private var baseURL: String {
        return "https://autenticacao.\(ambiente).tribofox.com.br/v1"
    }

    // MARK: - Buscar Empresas do Usuário
    func fetchCompanies(token: String, completion: @escaping (Result<[Empresa], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/usuario/empresas?paginacaoInicio=0&paginacaoQuantidadeRetorno=20") else {
            completion(.failure(NSError(domain: "URL inválida", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("false", forHTTPHeaderField: "tfx-tokendebug")
        
        print("🔵 [Request] GET \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [Erro ao enviar requisição] \(error.localizedDescription)")
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

            let responseString = String(data: data, encoding: .utf8) ?? "Resposta inválida"
            print("📩 [Resposta JSON] \(responseString)")

            if httpResponse.statusCode != 200 {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse.detail ?? "Erro desconhecido"
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                } catch {
                    completion(.failure(error))
                }
                return
            }

            do {
                let companies = try JSONDecoder().decode([Empresa].self, from: data)
                completion(.success(companies))
            } catch {
                print("❌ [Erro ao decodificar JSON] \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Autenticação de Empresa (POST)
    func authenticateCompany(companyId: Int, token: String, completion: @escaping (Result<EmpresaDetail, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login/empresas/\(companyId)/auth") else {
            completion(.failure(NSError(domain: "URL inválida", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("false", forHTTPHeaderField: "tfx-tokendebug")
        
        print("🔵 [Request] POST \(url.absoluteString)")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [Erro ao enviar requisição] \(error.localizedDescription)")
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

            let responseString = String(data: data, encoding: .utf8) ?? "Resposta inválida"
            print("📩 [Resposta JSON] \(responseString)")

            if httpResponse.statusCode != 200 {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse.detail ?? "Erro desconhecido"
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                } catch {
                    completion(.failure(error))
                }
                return
            }

            do {
                let companyDetail = try JSONDecoder().decode(EmpresaDetail.self, from: data)
                completion(.success(companyDetail))
            } catch {
                print("❌ [Erro ao decodificar JSON] \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
