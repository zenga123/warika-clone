// SettlementView.swift
import SwiftUI

struct SettlementView: View {
    let group: Group
    @State private var settlements: [Settlement] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text(group.name)
                    .font(.title2)
                    .padding(.top)
                
                if settlements.isEmpty {
                    Text("精算すべき金額はありません")
                        .padding()
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(settlements) { settlement in
                            HStack {
                                Text("\(settlement.from.name) → \(settlement.to.name)")
                                Spacer()
                                Text("¥\(Int(settlement.amount))")
                                    .font(.headline)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    Button(action: {
                        // Copy to clipboard for sharing
                    }) {
                        HStack {
                            Text("共有用にコピー")
                                .foregroundColor(.gray)
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("清算方法")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                settlements = group.calculateSettlement()
            }
        }
    }
}
