//
//  HeaderBanner.swift
//  Quotes4U
//
//  Created by John Phillip Lee on 1/14/21.
//

import SwiftUI

struct HeaderBanner: View {
    let bounds: CGRect
    
    var body: some View {
        ZStack(alignment: .bottomLeading){
            Trapezium(offsetPercentage: 0.85)
                .fill(Color.themeTertiary)
                .frame(height: bounds.height * 0.3)
                .shadow(radius: 10)
            
            Image(uiImage: UIImage(named: "kanye-banner")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: bounds.height * 0.3)
                .offset(x: 30.0)
                .clipShape(Trapezium(offsetPercentage: 0.85))
                .opacity(0.1)
            
            Text("Quotes by Kanye")
                .font(.largeTitle)
                .fontWeight(.bold)
                .offset(x: 50, y: -50)
                .foregroundColor(Color.themeForeground)
                .shadow(color: .white, radius: 0.4)
                .shadow(color: .white, radius: 0.4)
                .shadow(color: .white, radius: 0.4)
                .shadow(color: .white, radius: 0.4)
                .shadow(color: .white, radius: 0.4)
        }
    }
}

struct HeaderBanner_Previews: PreviewProvider {
    static var previews: some View {
        HeaderBanner(bounds: .init(x: 0, y: 0, width: 500, height: 400))
    }
}
