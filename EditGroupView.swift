// EditGroupView.swift
import SwiftUI

struct EditGroupView: View {
    @Binding var group: Group
    @Binding var isPresented: Bool
    @Binding var groupName: String
    @Binding var members: [Member]
    @Binding var newMemberName: String
    
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
                            TextField("新しいメンバー", text: $newMemberName)
                            
                            Button(action: {
                                if !newMemberName.isEmpty {
                                    members.append(Member(name: newMemberName))
                                    newMemberName = ""
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
                            ForEach(["JPY (¥)", "USD ($)", "EUR (€)", "GBP (£)", "KRW (₩)"], id: \.self) { currency in
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
                    group.name = groupName.isEmpty ? group.name : groupName
                    group.members = members
                    isPresented = false
                }) {
                    Text("変更を保存")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!(members.count < 2 || groupName.isEmpty) ? Color.walicaPrimary : Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
                .padding()
                .disabled(members.count < 2 || groupName.isEmpty)
            }
            .navigationTitle("グループを編集")
            .navigationBarItems(leading:
                Button("キャンセル") {
                    isPresented = false
                }
            )
        }
    }
}
