//
//  CategoryRow.swift
//  savingPot
//
//  Created by Tassja Bretz on 18.10.25.
//


import SwiftUI

struct CategoryRow: View {

    let isOutcome: Bool
    @Bindable var category: Category
    
    let currencyFormatter: NumberFormatter 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.iconName)
                    .resizable()
                    .modifier(roundImage())
                Spacer()
                
                Text(category.categoryName)
                    .font(.headline)
                    .frame(width: 120, alignment: .leading)
                Spacer()
                
                if (isOutcome == true) {
                    TextField("Budget", value: $category.budget, formatter: currencyFormatter)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: 100)
                }
          
            }
            
            Divider()
                .modifier(Line())
                .padding(.bottom, 4)
        }
    }
}
