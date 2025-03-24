//
//  CompanyViewModel.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 18/03/25.
//

import Foundation

class CompanyViewModel: ObservableObject {
    @Published var companies: [Empresa] = []
    @Published var selectedCompany: EmpresaDetail? = nil
    @Published var errorMessage: String? = nil
    @Published var authToken: String? // Token será passado ao inicializar o ViewModel

    // Função de inicialização
    init(authToken: String) {
        self.authToken = authToken
    }

    // Função para carregar a lista de empresas
    func fetchCompanies(completion: @escaping (Result<[Empresa], Error>) -> Void) {
        guard let token = authToken else {
            completion(.failure(NSError(domain: "Token não encontrado", code: 401, userInfo: nil)))
            return
        }
        
        CompaniesNetworkService.shared.fetchCompanies(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let empresas):
                    self.companies = empresas // Atualiza a lista de empresas
                    completion(.success(empresas))
                case .failure(let error):
                    self.errorMessage = "Erro ao carregar empresas: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }

    // Função para autenticar uma empresa
    func authenticateCompany(companyId: Int, completion: @escaping (Result<EmpresaDetail, Error>) -> Void) {
        guard let token = authToken else {
            completion(.failure(NSError(domain: "Token não encontrado", code: 401, userInfo: nil)))
            return
        }

        CompaniesNetworkService.shared.authenticateCompany(companyId: companyId, token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let companyDetail):
                    self.selectedCompany = companyDetail
                    completion(.success(companyDetail))
                case .failure(let error):
                    self.errorMessage = "Erro ao autenticar empresa: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
}
