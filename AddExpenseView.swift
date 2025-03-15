// AddExpenseView.swift
import SwiftUI

struct AddExpenseView: View {
    @Binding var group: Group
    @Binding var isPresented: Bool
    
    @State private var expenseName = ""
    @State private var amount = ""
    @State private var selectedPayer: Member?
    @State private var selectedParticipants: [Member] = []
    @State private var showingPayerSelection = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 헤더
                ZStack {
                    Rectangle()
                        .fill(Color.walicaPrimary)
                        .frame(height: 90)
                        .ignoresSafeArea(edges: .top)
                    
                    Text("Walica")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 지출자 선택
                        HStack(spacing: 12) {
                            Button(action: {
                                hideKeyboard()
                                showingPayerSelection = true
                            }) {
                                HStack {
                                    Text(selectedPayer?.name ?? "選択")
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 12)
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 12)
                                }
                                .frame(height: 50)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                                )
                            }
                            .frame(width: 200)
                            
                            Text("が")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 20)
                        
                        // 참가자 선택
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 12) {
                                                        ForEach(group.members) { member in
                                                            Button(action: {
                                                                toggleParticipant(member)
                                                            }) {
                                                                HStack {
                                                                    ZStack {
                                                                        Rectangle()
                                                                            .fill(selectedParticipants.contains(where: { $0.id == member.id }) ? Color.walicaPrimary : Color.white)
                                                                            .frame(width: 24, height: 24)
                                                                            .cornerRadius(4)
                                                                            .overlay(
                                                                                RoundedRectangle(cornerRadius: 4)
                                                                                    .stroke(Color.walicaPrimary, lineWidth: 1)
                                                                            )
                                                                        
                                                                        if selectedParticipants.contains(where: { $0.id == member.id }) {
                                                                            Image(systemName: "checkmark")
                                                                                .foregroundColor(.white)
                                                                                .font(.system(size: 14, weight: .bold))
                                                                        }
                                                                    }
                                                                    
                                                                    Text(member.name)
                                                                        .font(.system(size: 16))
                                                                        .foregroundColor(.primary)
                                                                        .padding(.leading, 8)
                                                                }
                                                                .padding(.vertical, 8)
                                                                .padding(.horizontal, 4)
                                                                .contentShape(Rectangle())
                                                            }
                                                            .buttonStyle(PlainButtonStyle())
                                                        }
                                                    }
                                                }
                                                .padding(.vertical, 8)
                        
                        // の
                        Text("の")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        
                        // 항목 입력
                        HStack {
                            TextField("タクシー代", text: $expenseName)
                                .padding()
                                .frame(height: 50)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                                )
                        }
                        
                        // を払って、
                        Text("を払って、")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        
                        // 금액 입력
                        HStack {
                            Text("¥")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                                .padding(.leading, 12)
                                .frame(width: 40)
                            
                            TextField("4800", text: $amount)
                                .keyboardType(.numberPad)
                                .padding()
                                .frame(height: 50)
                        }
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                        )
                        .padding(.bottom, 10)
                        
                        // かかった。
                        Text("かかった。")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .padding(.bottom, 50)
                        
                        // 등록 버튼
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
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.walicaPrimary)
                                )
                        }
                        .disabled(selectedPayer == nil || selectedParticipants.isEmpty || amount.isEmpty || expenseName.isEmpty)
                        .padding(.bottom, 10)
                        
                        // 뒤로 버튼
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("戻る")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(UIColor.systemGray))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor.systemGray6))
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .background(Color(UIColor.systemGray6))
                .edgesIgnoringSafeArea(.bottom)
                .simultaneousGesture(
                    TapGesture().onEnded { _ in
                        hideKeyboard()
                    }
                )
            }
            .background(Color(UIColor.systemGray6))
        }
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
        .actionSheet(isPresented: $showingPayerSelection) {
            ActionSheet(
                title: Text("支払った人を選択"),
                message: Text("誰が支払いましたか？"),
                buttons: payerActionButtons()
            )
        }
    }
    
    private func toggleParticipant(_ member: Member) {
        if let index = selectedParticipants.firstIndex(where: { $0.id == member.id }) {
            selectedParticipants.remove(at: index)
        } else {
            selectedParticipants.append(member)
        }
    }
    
    private func payerActionButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        // Add button for each member
        for member in group.members {
            buttons.append(
                .default(Text(member.name)) {
                    selectedPayer = member
                }
            )
        }
        
        // Add cancel button
        buttons.append(.cancel(Text("キャンセル")))
        
        return buttons
    }
}
