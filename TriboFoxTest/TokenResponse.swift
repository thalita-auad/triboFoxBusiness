//
//  TokenResponse.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 17/03/25.
//

import Foundation

struct TokenResponse: Codable {
    let dispositivo: Dispositivo?
    let usuario: Usuario?
    let empresa: Empresa?
    let token: TokenData
    let renovacaoToken: TokenData?
}

struct Dispositivo: Codable {
    let id: Int
    let apelido: String?
    let nome: String?
    let tipo: Int
    let pushNotificationUuid: String
}

struct Usuario: Codable {
    let id: Int
    let nome: String
    let status: Int?
    let foto: String?
    let cpf: String?
    let celular: String?
    let email: String?
    let grupoId: Int?
    let grupoDescricao: String?
    let contatos: [Contato]?
    let permissoes: [Permissao]?
    let senha: String?
    let timeZone: String?
}

struct Contato: Codable {
    let tipo: Int
    let valor: String
}

struct Permissao: Codable {
    let id: Int
}

struct Empresa: Codable {
    let id: Int
    let cpfCnpj: String
    let nome: String
    let fantasia: String
    let empresaDispositivoVinculado: Bool
    let empresaDispositivoLiberado: Bool
    let licencaDisponivel: Bool
}

struct EmpresaDetail: Codable {
    let id: Int
    let status: Int
    let permissoes: [Permissao]
    let grupoDescricao: String?
}

struct TokenData: Codable {
    let tokenId: String
    let criadoEm: String
    let validade: String
    let expiresMilliseconds: Int
    let count: Int
    let regras: [String]
    let timeZoneWindows: String?
    let timeZoneIana: String?
}
