//
//  TaxEntryEditorView.swift
//  FizzDutyCalc
//
//  Created by 莊羚羊 on 2025/11/15.
//

import SwiftUI

struct TaxEntryEditorView: View {
    @StateObject var vm = TaxEntryEditorViewModel()
    var body: some View {
        VStack {
            nameView()
            isDutyFreeIncludedView()
            categoryPicker(selection: $vm.dutyRecode.exciseTaxCategory)
            categoryPicker(selection: $vm.dutyRecode.tariffCategory)
            inputNumberView(title: "容量", value: $vm.dutyRecode.volumeInML, unit: "ml")
            inputNumberView(title: "酒精濃度", value: $vm.dutyRecode.alcoholPercentage, unit: "%")
            Spacer()
            finishButton()
        }
        .padding()
    }

    @MainActor
    @ViewBuilder
    func nameView() -> some View {
        HStack {
            Text("名稱")
                .padding(.trailing)

            TextField("請輸入名稱", text: $vm.dutyRecode.name)
                .padding()
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

        }
        .frame(maxWidth: .infinity)
    }
    @MainActor
    @ViewBuilder
    func isDutyFreeIncludedView() -> some View {
        Toggle("是否納入免稅額", isOn: $vm.dutyRecode.isDutyFreeIncluded)
            .frame(maxWidth: .infinity)
    }
    @MainActor
    @ViewBuilder
    func categoryPicker<T: Catrgory>(
        title: String = T.modelName,
        selection: Binding<T>
    ) -> some View {
        HStack {
            Text(title)
                .padding(.trailing)
            Spacer()
            Picker(title, selection: selection) {
                ForEach(Array(T.allCases), id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.menu)
            .frame(height: 50)
        }
    }

    @MainActor
    @ViewBuilder
    func tariffCategoryView() -> some View {

        HStack {
            Text("酒品種類（關稅）")
                .padding(.trailing)
            Spacer()
            Picker("酒品種類（酒稅）", selection: $vm.dutyRecode.tariffCategory) {
                ForEach(TariffCategory.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }

        }
        .frame(maxWidth: .infinity)
    }

    @MainActor
    @ViewBuilder
    func inputNumberView(
        title: String,
        value: Binding<Double>,
        unit: String
    ) -> some View {
        HStack {
            Text(title)
                .padding(.trailing)
                
            
            TextField("請輸入\(title)", value: value, format: .number)
                .padding()
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .keyboardType(.decimalPad)
            Text(unit)
        }
        .frame(maxWidth: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    func finishButton() -> some View {
        Button {
            
        } label: {
            Text("下一筆")
                .foregroundStyle(Color.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                )
        }

    }
}

#Preview {
    TaxEntryEditorView()
}

class TaxEntryEditorViewModel: ObservableObject {
    @Published var dutyRecode: DutyRecord = .init()
}
protocol Catrgory: Codable, CaseIterable, Hashable, RawRepresentable
where RawValue == String {
    static var modelName: String { get }
}
enum ExciseTaxCategory: String, Catrgory {
    static var modelName = "酒品種類（酒稅）"

    case beer = "釀造酒類（啤酒）"
    case brewedOthers = "釀造酒類（其他釀造酒，例：清酒）"
    case spirits = "蒸餾酒類"
    case processedOver20 = "再製酒類（>20%）"
    case processedUnder20 = "再製酒類（<=20%）"
    case cookingWine = "料理酒"
    case others = "其他酒類"
    case alcohol = "酒精"

}

enum TariffCategory: String, Catrgory {
    case wine = "紅白酒 / 加烈酒"
    case sake = "清酒"
    case shochu = "日本燒酌"
    case beer = "啤酒"
    case spiritsGroup = "葡萄白蘭地 / 威士忌 / 蘭姆酒 / 琴酒 / 伏特加 / 利口酒 / 水果白蘭地 / 龍舌蘭"
    case fermentedDrinks = "發酵穀類酒 / 發酵果實酒 / 蜂蜜酒"
    case champagneGroup = "香檳 / 氣泡酒 / 苦艾酒"
    static var modelName = "酒品種類（關稅）"
}

struct DutyRecord: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    /// 是否納入免稅額
    var isDutyFreeIncluded: Bool = false
    /// 酒品種類（酒稅）
    var exciseTaxCategory: ExciseTaxCategory = .beer
    /// 酒品種類（關稅）
    var tariffCategory: TariffCategory = .beer
    /// 容量（ml）
    var volumeInML: Double = 0
    /// 酒精濃度 (%)
    var alcoholPercentage: Double = 0
}
