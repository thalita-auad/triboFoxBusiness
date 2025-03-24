//
//  TriboFoxTestApp.swift
//  TriboFoxTest
//
//  Created by Thalita Auad on 10/03/25.
//

import SwiftUI

@main
struct TriboFoxTestApp: App {
    @StateObject private var loginViewModel = LoginViewModel() 

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
