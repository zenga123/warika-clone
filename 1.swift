// CreateGroupView.swift
import SwiftUI

struct CreateGroupView: View {
    @Binding var groups: [Group]
    @Binding var isPresented: Bool
    
    @State private var groupName: String = ""
    @State private var memberName: String = ""
    @State private var members: [Member] = []
    @State private var showCurrencyPicker = false
    @State private var selectedCurrency = "JPY (¥)"
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("グループ名")) {
                        TextField("グループ名", text: $groupName)
                    }
                    
                    Section(header: Text("メンバー名")) {
                        HStack {
                            TextField("メンバー名", text: $memberName)
                            
                            Button(action: {
                                if !memberName.isEmpty {
                                    members.append(Member(name: memberName))
                                    memberName = ""
                                }
                            }) {
                                Text("追加")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.walicaPrimary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    if !members.isEmpty {
                        Section(header: Text("メンバー一覧")) {
                            ForEach(members) { member in
                                Text(member.name)
                            }
                            .onDelete { indexSet in
                                members.remove(atOffsets: indexSet)
                            }
                        }
                    }
                    
                    Section(header: Text("外貨を選択")) {
                        Button(action: {
                            showCurrencyPicker.toggle()
                        }) {
                            HStack {
                                Text("通貨")
                                Spacer()
                                Text(selectedCurrency)
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(showCurrencyPicker ? 180 : 0))
                            }
                        }
                        
                        if showCurrencyPicker {
                            ForEach(["JPY (¥)", "USD ($)", "EUR (€)", "GBP (£)"], id: \.self) { currency in
                                Button(action: {
                                    selectedCurrency = currency
                                    showCurrencyPicker = false
                                }) {
                                    HStack {
                                        Text(currency)
                                        Spacer()
                                        if currency == selectedCurrency {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.walicaPrimary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button(action: {
                    let newGroup = Group(name: groupName.isEmpty ? "新しいグループ" : groupName, members: members)
                    groups.append(newGroup)
                    isPresented = false
                }) {
                    Text("グループを作成")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.walicaPrimary)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(members.isEmpty)
            }
            .navigationTitle("Walica")
            .navigationBarItems(leading:
                Button("キャンセル") {
                    isPresented = false
                }
            )
        }
    }
}
