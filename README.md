# CCDB-Client
[CCDB-Server]()をComputerCraftから扱うAPI

## How to use
### 使う準備
#### APIのダウンロード
1. オフラインで扱う場合(準備はオンライン必須),コンピュータで以下を実行(初回一回のみ)  
  ```lua
  loadstring(http.get("https://raw.githubusercontent.com/neverclear86/CCDB-Client/master/download.lua").readAll())()
  ```
2. CCDBの読み込み(CCDBを扱うプログラムファイル内)  
  ```lua
  -- オフラインの場合
  local ccdb = loadstring(fs.open("ccdb.lua", "r").readAll())()
  -- オンラインの場合
  local ccdb = loadstring(http.get("https://raw.githubusercontent.com/neverclear86/CCDB-Client/master/ccdb.lua").readAll())()
  ```
#### ユーザ操作
- ユーザ登録
```lua
ccdb.user.insert("ユーザ名", "パスワード")
```
- パスワード変更
```lua
ccdb.user.updatePassword("ユーザ名", "現パスワード", "新パスワード")
```

### 使い方
- グローバル設定  
  毎回ユーザ名、パスワードを入力しなくてよくなる
```lua
ccdb.setUsername("ユーザ名")
ccdb.setPassword("パスワード")
```

- データ検索

```lua
local response = ccdb.find("コレクション名", {条件}, {ソート条件})

-- ※グローバル設定を使わない場合
local local response = ccdb.find("コレクション名", {条件}, {ソート条件}, "ユーザ名", "パスワード")
```
