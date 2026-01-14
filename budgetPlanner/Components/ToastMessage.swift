//
//  ToastMessage.swift
//  savingPot
//
//  Created by Tassja Bretz on 20.12.25.
//

import Foundation
import SwiftUI

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval



        func body(content: Content) -> some View {
            content
                .overlay(
                    ZStack {
                        if isShowing {
                            VStack {
                                Spacer()
                                Text(message)
                                    .font(.subheadline)
                                    .foregroundColor(.adaptiveWhiteCard)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.adaptiveBlack.opacity(0.8)))
                                    .shadow(radius: 10)
                            }
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                    withAnimation {
                                        isShowing = false
                                    }
                                }
                            }
                        }
                    }
      
                    .allowsHitTesting(false)
                )
        }
    }


extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: TimeInterval = 3) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, duration: duration))
    }
}
    
  

