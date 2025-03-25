//
//  CompanyDetailView.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 18/03/25.
//

import SwiftUI

struct CompanyDetailView: View {
    var company: Empresa
    @ObservedObject var viewModel: CompanyViewModel
    @State private var companyDetails: EmpresaDetail? = nil

    var body: some View {
        VStack {
            Text(company.nome)
                .font(.largeTitle)
                .bold()
            Text(company.fantasia)
                .font(.title2)
                .foregroundColor(.gray)

            Button("Carregar Detalhes") {
                loadCompanyDetails()
            }
            .padding()

            if let details = companyDetails {
                VStack {
                    Text("Status: \(details.status)")
                    Text("Grupo: \(details.grupoDescricao ?? "N/A")")
                    // add mais detalhes depois
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            loadCompanyDetails()
        }
    }

    func loadCompanyDetails() {
        viewModel.authenticateCompany(companyId: company.id) { result in
            switch result {
            case .success(let details):
                companyDetails = details
            case .failure(let error):
                print("Erro ao carregar detalhes da empresa: \(error)")
            }
        }
    }
}

struct CompanyDetailViewPreviews: PreviewProvider {
    static var previews: some View {
        let company = Empresa(id: 517, cpfCnpj: "08370599000167", nome: "DESENVOLVIMENTO", fantasia: "TRIBOFOX DESENVOLVIMENTO", empresaDispositivoVinculado: true, empresaDispositivoLiberado: true, licencaDisponivel: true)
        let viewModel = CompanyViewModel(authToken: "token") // Substitua com um token válido
        return CompanyDetailView(company: company, viewModel: viewModel)
    }
}

