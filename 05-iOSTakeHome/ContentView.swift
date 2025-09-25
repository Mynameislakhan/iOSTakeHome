//
//  ContentView.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 15/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            print("👇 Users Response")
//            dump {
//                try? StaticJSONMapper.decode(file: "UserStaticData.json", type: UsersResponse.self)
//            }
            print(try! StaticJSONMapper.decode(file: "UserStaticData.json", type: UsersResponse.self))
            print("👇 Single User Response")
//            dump {
//                try? StaticJSONMapper.decode(file: "SingleUserData.json", type: UserDetailResponse.self)
//            }
            print(try! StaticJSONMapper.decode(file: "SingleUserData.json", type: UserDetailResponse.self))
        }
    }
}

#Preview {
    ContentView()
}
