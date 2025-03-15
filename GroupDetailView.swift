// GroupDetailView.swift
import SwiftUI

struct GroupDetailView: View {
    @Binding var group: Group
    @State private var isAddingExpense = false
    @State private var showingSettlement = false
    
    var body: some View {
        VStack {
            HStack {
                Text(group.name)
                    .font(.title)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    // Edit group name
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.walicaPrimary)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .padding(.vertical)
            .background(Color.walicaPrimary)
            .foregroundColor(.white)
            
            Text("\(group.members.map { $0.name }.joined(separator: " · "))")
                .foregroundColor(Color.gray)
                .padding(.bottom)
            
            Button(action: {
                isAddingExpense = true
            }) {
                Text("立替え記録を追加")
                    .foregroundColor(Color.walicaPrimary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.walicaPrimary, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            if group.expenses.isEmpty {
                Spacer()
                Text("立替え記録がありません")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(group.expenses) { expense in
                        VStack(alignment: .leading) {
                            Text(expense.title)
                                .font(.headline)
                            
                            HStack {
                                Text("\(expense.paidBy.name)が立替え (\(formatDate(expense.date)))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("¥\(Int(expense.amount))")
                                    .font(.headline)
                            }
                            
                            HStack {
                                ForEach(expense.participants, id: \.self) { participant in
                                    Text(participant.name)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Circle().fill(Color.walicaPrimary.opacity(0.2)))
                                        .foregroundColor(Color.walicaPrimary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            
            if !group.expenses.isEmpty {
                Button(action: {
                    showingSettlement = true
                }) {
                    Text("明細を見る")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.walicaBackground)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $isAddingExpense) {
            AddExpenseView(group: $group, isPresented: $isAddingExpense)
        }
        .sheet(isPresented: $showingSettlement) {
            SettlementView(group: group)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
