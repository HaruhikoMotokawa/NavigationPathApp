//
//  ContentView.swift
//  NavigationPath
//
//  Created by 本川晴彦 on 2023/10/27.
//

import SwiftUI
/// 選択した名称で使えるようにStringに準拠
/// 尚且つNavigationPathで使えるようにHashableに準拠したStringに準拠する
enum MacType: String {
  case MacBook, iMac, MacStudio
}
/// ダミーデータの構造体、ForEachで使用できるようにIdentifiableに準拠
struct Mac: Identifiable {
  var id = UUID()
  var pathName: MacType
}
/// ダミーデータとして宣言
extension Mac {
  static let models: [Mac] = [
    Mac(pathName: .MacBook),
    Mac(pathName: .MacStudio),
    Mac(pathName: .iMac)
  ]
}
/// 親画面
struct MacSelectView: View {
  /// 大元のViewでNavigationPathを@ Stateで宣言して、子Viewにバインディングしていく
  @State private var path: NavigationPath = NavigationPath()

  var body: some View {
    NavigationStack(path: $path) { // ここで使用するパスを設定
      List {
        Section {
          ForEach(Mac.models) { model in
            // ただ遷移させるだけなら(destination:label:)を使う
            NavigationLink {
              IPadSelectView(
                path: $path,
                selectedMac: model.pathName
              )
            } label: {
              // 文字列が欲しい場合は今回はenum MacType: Stringなので
              // .rawValueでcaseに設定した文字列がそのまま渡される
              Text(model.pathName.rawValue)
            }
          }
        } header: {
          Text("標準的なナビゲーションリンクでの遷移")
        } footer: {
          Text("パス使ってないので、今回は遷移後に次のViewに行こうとするとバグります")
        }
        Section {
          ForEach(Mac.models) { model in
            // 今回はパスを使って遷移させるので(value:label:)を選択
            NavigationLink(value: model.pathName) {
              Text(model.pathName.rawValue)
            }
          }
        } header: {
          Text("ナビゲーションパスでの遷移")
        } footer: {
          Text("パスでの遷移を始めたら次の遷移もパスを指定しないと表示がバグります")
        }
        Section {
          Button("次の画面へ飛ぶ") {
            path.append(MacType.MacStudio)
          }
          Button("次のその次の画面へ飛ぶ") {
            path.append(MacType.MacBook)
            path.append(IPadType.Mini)
          }
          Button("最後の画面へ飛ぶ") {
            path.append(MacType.iMac)
            path.append(IPadType.Air)
            path.append(IPhoneType.SE)
          }
          Button("最後の画面へ飛ぶSEだけ選択（バグる）") {
            // バグります
            path.append(IPhoneType.SE)
          }
          .foregroundStyle(.red)

        } header: {
          Text("パスを追加で一気に進む")
        }
      } // List
      // 以下で遷移先を指定する。使用するハッシュ値を(for:)で指定。
      // ハッシュ値によって渡す値を帰るのでswitch文で分岐
      .navigationDestination(for: MacType.self) { path in
        switch path {
          case .MacBook:
            IPadSelectView(path: $path, selectedMac: .MacBook)
          case .iMac:
            IPadSelectView(path: $path, selectedMac: .iMac)
          case .MacStudio:
            IPadSelectView(path: $path, selectedMac: .MacStudio)
        }
      } // navigationDestination
      .navigationTitle("Root")
    } // NavigationStack
  } // body
}

enum IPadType: String, Hashable {
  case Mini, Air, Pro
}

struct IPad: Identifiable {
  var id = UUID()
  var pathName: IPadType
}

extension IPad {
  static let models: [IPad] = [
    IPad(pathName: .Mini),
    IPad(pathName: .Air),
    IPad(pathName: .Pro)
  ]
}
/// ２つ目の画面
struct IPadSelectView:View {
  /// パスをバインディング
  @Binding var path: NavigationPath
  /// 前の画面で選択されたMacType
  var selectedMac: MacType

  var body: some View {
    List {
      Section {
        Text("あなたが選択したMacは「 \(selectedMac.rawValue) 」")
      }
      ForEach(IPad.models) { model in
        NavigationLink(value: model.pathName) {
          Text(model.pathName.rawValue)
        }
      }
    } // List
    .navigationDestination(for: IPadType.self) { path in
      switch path {
        case .Mini:
          IPhoneSelectView(
            path: $path,
            selectedMac: selectedMac,
            selectedIPad: .Mini
          )
        case .Air:
          IPhoneSelectView(
            path: $path,
            selectedMac: selectedMac,
            selectedIPad: .Air
          )
        case .Pro:
          IPhoneSelectView(
            path: $path,
            selectedMac: selectedMac,
            selectedIPad: .Pro
          )
      }
    }
    .navigationTitle("Second")
  } // body
}
enum IPhoneType: String, Hashable {
  case SE, Pro, ProMax
}

struct IPhone: Identifiable {
  var id = UUID()
  var pathName: IPhoneType
}

extension IPhone {
  static let models: [IPhone] = [
    IPhone(pathName: .SE),
    IPhone(pathName: .Pro),
    IPhone(pathName: .ProMax)
  ]
}
/// ３つ目の画面
struct IPhoneSelectView:View {

  @Binding var path: NavigationPath

  var selectedMac: MacType

  var selectedIPad: IPadType

  var body: some View {
    List {
      Section {
        Text("あなたが選択したMacは「 \(selectedMac.rawValue) 」")
        Text("あなたが選択したiPadは「 \(selectedIPad.rawValue) 」")
      }
      ForEach(IPhone.models) { model in
        NavigationLink(value: model.pathName) {
          Text(model.pathName.rawValue)
        }
      }
    } // List
    .navigationDestination(for: IPhoneType.self) { path in
      switch path {
        case .SE:
          ResultView(
            path: $path,
            selectedMac: selectedMac,
            selectedIPad: selectedIPad,
            selectedIPhone: .SE
          )
        case .Pro:
          ResultView(
            path: $path,
            selectedMac: selectedMac,
            selectedIPad: selectedIPad,
            selectedIPhone: .Pro
          )
        case .ProMax:
          ResultView(
            path: $path,
            selectedMac: selectedMac,
            selectedIPad: selectedIPad,
            selectedIPhone: .ProMax
          )
      }
    }
    .navigationTitle("Third")
  } // body
}
struct ResultView:View {
  /// 画面を閉じるための環境変数
  @Environment(\.dismiss) var dismiss

  @Binding var path: NavigationPath

  var selectedMac: MacType

  var selectedIPad: IPadType

  var selectedIPhone: IPhoneType

  var body: some View {
    VStack(spacing: 50) {
      Form {
        Section {
          Text("あなたが選択したMacは「 \(selectedMac.rawValue) 」")
          Text("あなたが選択したiPadは「 \(selectedIPad.rawValue) 」")
          Text("あなたが選択したiPhoneは「 \(selectedIPhone.rawValue) 」")
        }
        Button("一つ前に戻る　Third") {
          path.removeLast() // 最後に追加したパスを削除する、つまり閉じる
        }
        Button("二つ前に戻る　Second") {
          path.removeLast(2) // 最後とその前に追加したパスを削除する、つまり２つ画面を閉じる
        }
        Button("最初に戻る Root") {
          // パスに格納されている分だけ削除、つまり全部削除、つまり全部閉じる
          path.removeLast(path.count)
        }
        Button("dismissで閉じる") {
          dismiss() // この画面を閉じる
        }
      }
      .navigationTitle("Last")
    } // VStack
  } // body
}

#Preview("ContentView") {
  MacSelectView()
}
#Preview("LastView") {
  ResultView(
    path: Binding.constant(NavigationPath()),
    selectedMac: .MacBook,
    selectedIPad: .Air, selectedIPhone: .SE
  )
}
