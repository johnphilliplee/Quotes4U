//
//  ContentView.swift
//  Quotes4U
//
//  Created by John Lee on 1/12/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    @State private var isQuoteCardVisible = false
    @State private var cardTranslation: CGSize = .zero
    @State private var isFetchingQuote = false
    @State private var hudOpacity: Double = 0
    @State private var presentSavedJokes = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var bounds: CGRect {
        UIScreen.main.bounds
    }
    
    private var translation: Double { Double(cardTranslation.width / bounds.width) }
    
    private var rotationAngle: Angle {
        return Angle(degrees: 75 * translation)
    }
    
    private var circleDiameter: CGFloat { bounds.width * 0.8 }
    
    fileprivate func quoteCardView() -> some View {
        QuoteCardView(quote: viewModel.quote.quote)
            .frame(width: min(300, bounds.width * 0.7), height: min(400, bounds.height * 0.7))
            .background(viewModel.backgroundColor)
            .foregroundColor(Color.themeBackground)
            .cornerRadius(10)
            .shadow(radius: 20)
            .rotationEffect(rotationAngle)
            .offset(x: cardTranslation.width, y: cardTranslation.height)
            .gesture(
                DragGesture()
                    .onChanged { change in
                        let translation = change.translation
                        cardTranslation = CGSize(width: translation.width,
                                                 height: translation.height)
                        updateBackgroundColor()
                    }
                    .onEnded { change in
                        updateDecisionStateForChange(change)
                        handle(change)
                    }
            )
    }
    
    var body: some View {
        VStack {
            HeaderBanner(bounds: bounds)
            
            ZStack {
                HStack {
                    Circle()
                        .trim(from: 0.5, to: 1)
                        .stroke(Color.gray, lineWidth: 4)
                        .frame(width: circleDiameter, height: circleDiameter)
                        .rotationEffect(.degrees(isFetchingQuote ? 0 : -360))
                        .animation(
                            Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false)
                        )
                }
                .opacity(isFetchingQuote ? 0.2 : 0)
                
                HudView(imageType: .down)
                    .frame(width: min(200, bounds.width * 0.7), height: min(300, bounds.height * 0.7))
                    .opacity(viewModel.decisionState == .liked ? hudOpacity : 0)
                    .animation(.linear)
                
                HudView(imageType: .cross)
                    .frame(width: min(200, bounds.width * 0.7), height: min(300, bounds.height * 0.7))
                    .opacity(viewModel.decisionState == .disliked ? hudOpacity : 0)
                    .animation(.linear)
                
                
                quoteCardView()
                    .opacity(isQuoteCardVisible ? 1 : 0)
                    .offset(x: 0, y: isQuoteCardVisible ? 0 : -bounds.height)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.5))
            }.padding()
            Spacer()
            Button(action: {presentSavedJokes = true}) {
                ZStack {
                    Rectangle()
                        .fill(Color.accentColor)
                    Text("View Saved Quotes")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.themeBackground)
                }
            }.frame(width: bounds.width * 0.8, height: 55)
            .shadow(radius: 5)
            Spacer()
        }
        .background(Color.themeBackground)
        .edgesIgnoringSafeArea(.vertical)
        .onAppear(perform: reset)
        .sheet(isPresented: $presentSavedJokes) {
            SavedQuotesView()
                .environment(\.managedObjectContext, self.viewContext)
        }

    }
    
    private func updateBackgroundColor() {
        viewModel.updateBackgroundColorBasedOnTranslation(translation)
    }
    
    private func updateDecisionStateForChange(_ change: DragGesture.Value) {
        viewModel.updateDecisionStateForTranslation(
            translation,
            andPredictedEndLocationX: change.predictedEndLocation.x,
            inBounds: bounds
        )
    }
    
    private func handle(_ change: DragGesture.Value) {
        let decisionState = viewModel.decisionState
        
        switch decisionState {
        case .neutral:
            cardTranslation = .zero
            viewModel.reset()
        case .liked, .disliked:
            if decisionState == .liked {
                QuoteManagedObject.save(quote: viewModel.quote, inViewContext: viewContext)
            }
            
            let translation = change.translation
            let offset = (decisionState == .liked ? 2 : -2) * bounds.width
            cardTranslation = CGSize(width: translation.width + offset,
                                     height: translation.height)
            isQuoteCardVisible = false
            
            reset()
        }
    }
    
    private func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.reset()
            hudOpacity = 1.0
            cardTranslation = .zero
            isFetchingQuote = true
            viewModel.fetchQuote()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hudOpacity = 0
                isFetchingQuote = false
                isQuoteCardVisible = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
