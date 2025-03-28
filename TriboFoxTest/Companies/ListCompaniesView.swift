//
//  ListCompaniesView.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 18/03/25.
//

import SwiftUI

struct ListCompaniesView: View {
    @ObservedObject var viewModel: CompanyViewModel
    @State private var selectedCompany: Empresa? = nil
    @State private var isCompanySelected = false
    @State private var searchText: String = ""  
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top)
                
                // Lista de Empresas
                if viewModel.companies.isEmpty {
                    Text("Nenhuma empresa encontrada.")
                        .padding()
                } else {
                    List(viewModel.companies, id: \.id) { empresa in
                        Button(action: {
                            selectedCompany = empresa
                            isCompanySelected = true
                        }) {
                            CompanyRowView(company: empresa)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Empresas")
            .onAppear {
                loadCompanies()
            }
            .fullScreenCover(isPresented: $isCompanySelected) {
                if let company = selectedCompany {
                    CompanyDetailView(company: company, viewModel: viewModel)
                }
            }
        }
    }
    
    func loadCompanies() {
        viewModel.fetchCompanies { result in
            switch result {
            case .success(let empresas):
                break
            case .failure(let error):
                print("Erro ao carregar empresas: \(error)")
            }
        }
    }
}

struct CompanyRowView: View {
    var company: Empresa
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(company.nome)
                .font(.headline)
            Text(company.fantasia)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("CNPJ: \(company.cpfCnpj)")
                .font(.footnote)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Pesquise empresas", text: $text)
            .padding(7)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}


struct ListCompaniesViewPreviews: PreviewProvider {
    static let viewModel = CompanyViewModel(authToken: "token")
    static var previews: some View {
        ListCompaniesView(viewModel: viewModel)
    }
}
