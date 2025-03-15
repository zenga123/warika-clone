// AddExpenseView.swift
import SwiftUI

struct AddExpenseView: View {
    @Binding var group: Group
    @Binding var isPresented: Bool
    
    @State private var expenseName = ""
    @State private var amount = ""
    @State private var selectedPayer: Member?
    @State private var selectedParticipants: [Member] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Button(action: {
                            // Toggle dropdown for participants
                        }) {
                            HStack {
                                Text(selectedPayer?.name ?? "選択")
                                Image(systemName: "chevron.down")
                            }
                            .frame(width: 150, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.walicaBackground)
                            .cornerRadius(8)
                        }
                        
                        Text("が")
                    }
                    
                    TextField("タクシー代", text: $expenseName)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.walicaBackground)
                        .cornerRadius(8)
                        .padding(.vertical, 4)
                    
                    Text("を払って、")
                    
                    HStack {
                        Text("¥")
                        TextField("4800", text: $amount)
                            .keyboardType(.numberPad)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.walicaBackground)
                            .cornerRadius(8)
                    }
                    
                    Text("かかった。")
                    
                    Section(header: Text("参加者")) {
                        ForEach(group.members) { member in
                            HStack {
                                Text(member.name)
                                Spacer()
                                if selectedParticipants.contains(where: { $0.id == member.id }) {
                                    Image(systemName: "checkmark.square.fill")
                                        .foregroundColor(Color.walicaPrimary)
                                } else {
                                    Image(systemName: "square")
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let index = selectedParticipants.firstIndex(where: { $0.id == member.id }) {
                                    selectedParticipants.remove(at: index)
                                } else {
                                    selectedParticipants.append(member)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("戻る")
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.walicaBackground)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let payer = selectedPayer,
                           !selectedParticipants.isEmpty,
                           let amountValue = Double(amount),
                           !expenseName.isEmpty {
                            
                            let newExpense = Expense(
                                title: expenseName,
                                amount: amountValue,
                                paidBy: payer,
                                participants: selectedParticipants,
                                date: Date()
                            )
                            
                            group.expenses.append(newExpense)
                            isPresented = false
                        }
                    }) {
                        Text("登録")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.walicaPrimary)
                            .cornerRadius(8)
                    }
                    .disabled(selectedPayer == nil || selectedParticipants.isEmpty || amount.isEmpty || expenseName.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Walica")
            .onAppear {
                // Set default payer to first member
                if selectedPayer == nil && !group.members.isEmpty {
                    selectedPayer = group.members.first
                }
                
                // Set default participants to all members
                if selectedParticipants.isEmpty {
                    selectedParticipants = group.members
                }
            }
        }
    }
}
