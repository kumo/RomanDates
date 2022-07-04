//
//  PurchasingView.swift
//  RomanDates
//
//  Created by Robert Clarke on 14/06/21.
//

import SwiftUI
import Purchases

/*
 An example paywall that uses the current offering.
 */

struct PurchasingView: View {
    private var subscriptionManager: IAPManager = IAPManager()

        var body: some View {
            VStack {
                Text("Tip Jar")
                    .font(.largeTitle)
                    .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("If you love this app or if it has been useful for you, you can leave a tip to cover development cost! Any tip at all helps a lot!")
                        .fontWeight(.semibold)
                }
                .padding()

                ScrollView {
                    ForEach(subscriptionManager.packages, id: \.identifier) { product in
                        Button(action: {
                            subscriptionManager.purchase(product: product)
                        }) {
                            IAPRow(product: product)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    

}

struct IAPRow: View {
    var product: Purchases.Package

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.product.localizedTitle).bold()
             //   Text(product.product.localizedDescription)
            }

            Spacer()

        Text(product.localizedPriceString).bold()
            .foregroundColor(.white)
                           .padding(4)
                           .background(Color.yellow)
                           .cornerRadius(8)
        }
        .foregroundColor(.primary)
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}
