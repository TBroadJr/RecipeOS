//
//  CreateView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct CreateView: View {
    
    @State private var avatarImage = UIImage(named: "Avatar Default")
    
    var body: some View {
        Text("Create")
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
