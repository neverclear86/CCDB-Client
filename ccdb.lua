---
-- CCDB Client
-- (c) 2017 neverclear
-- @author neverclear
--

-- json.lua Copyright (c) 2015 rxi
local json = loadstring(http.get("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").readAll())()

--------------------------------------------------------------------------------------
local url = "http://neverclear.net:55440/api"

local ccdb = {}

--- グローバルユーザ名
local username = nil
--- グローバルパスワード
local password = nil


---
-- グローバルユーザ名取得
-- @return ユーザ名
function ccdb.getUsername()
  return username
end
---
-- グローバルユーザ名設定
-- @param name  ユーザ名
function ccdb.setUsername(name)
  username = name
end

---
-- グローバルパスワード取得
-- @return パスワード
function ccdb.getPassword()
  return password
end
---
-- グローバルパスワード設定
-- @param pass  パスワード
function ccdb.setPassword(pass)
  password = pass
end

---
-- ユーザ名、パスワードが引数で設定されていない場合グローバル
-- @param name  ユーザ名
-- @param pass  パスワード
-- @return ユーザ名, パスワード
local function getUser(name, pass)
  if not (name and pass) then
    return ccdb.getUsername(), ccdb.getPassword()
  else
    return name, pass
  end
end
--------------------------------------------------------------------------
---
-- 正規表現オペレータ生成
-- @param       regex   正規表現
-- @param[opt]  option  オプション
-- @return              正規表現オペレータ
function ccdb.regex(regex, option)
  return {["$regex"] = regex, ["$options"] = option}
end

---------------------------------------------------------------------------

ccdb.user = {}

---
-- CCDBにユーザを登録する
-- @param   name  ユーザ名
-- @param   pass  パスワード
-- @return        API Response
function ccdb.user.insert(name, pass)
  local param =
    "username=" .. name ..
    "&password=" .. pass
  local h = http.post(url .. "/user/insert/", param)
  return json.decode(h.readAll())
end

---
-- CCDBにユーザを登録する
-- @param  name     ユーザ名
-- @param  pass     パスワード
-- @param  newPass  新しいパスワード
-- @return          API Response
function ccdb.user.updatePassword(name, pass, newPass)
  local param =
    "username=" .. name ..
    "&password=" .. pass ..
    "&newPassword=" .. newPass
  local h = http.post(url .. "/user/update/", param)
  return json.decode(h.readAll())
end

-- function ccdb.user.delete(name, pass)
--
-- end

--------------------------------------------------------------------------

---
-- 検索
-- @param       collection  コレクション名
-- @param       query       検索条件
-- @param[opt]  name        ユーザ名
-- @param[opt]  pass        パスワード
-- @return                  API Response
function ccdb.find(collection, query, name, pass)
  name, pass = getUser(name, pass)
  local param =
    "username=" .. name ..
    "&password=" .. pass ..
    "&collection=" .. collection ..
    "&query=" .. json.encode(query)
  local h = http.get(url .. "/db/find/?" .. param)
  return json.decode(h.readAll())
end

---
-- 挿入
-- @param       collection  コレクション名
-- @param       data        挿入データ
-- @param[otp]  name        ユーザ名
-- @param[opt]  pass        パスワード
-- @return                  API Response
function ccdb.insert(collection, data, name, pass)
  name, pass = getUser(name, pass)
  local param =
    "username=" .. name ..
    "&password=" .. pass ..
    "&collection=" .. collection ..
    "&data=" .. json.encode(data)
  local h = http.post(url .. "/db/insert/", param)
  return json.decode(h.readAll())
end

---
-- 更新
-- @param       collection  コレクション名
-- @param       selector    検索条件
-- @param       data        更新データ
-- @param[opt]  name        ユーザ名
-- @param[opt]  pass        パスワード
-- @return                  API Response
function ccdb.update(collection, selector, data, name, pass)
  name, pass = getUser(name, pass)
  data = {["$set"] = data}
  local param =
    "username=" .. name ..
    "&password=" .. pass ..
    "&collection=" .. collection ..
    "&selector=" .. json.encode(selector) ..
    "&data=" .. json.encode(data)

  local h = http.post(url .. "/db/update/", param)
  return json.decode(h.readAll())
end

---
-- 削除
-- @param       collection  コレクション名
-- @param       filter      検索条件
-- @param[opt]  name        ユーザ名
-- @param[opt]  pass        パスワード
-- @return                  API Response
function ccdb.delete(collection, filter, name, pass)
  name, pass = getUser(name, pass)
  local param =
    "username=" .. username ..
    "&password=" .. password ..
    "&collection=" .. collection ..
    "&filter=" .. json.encode(filter)

  local h = http.post(url .. "/db/delete/", param)
  return json.decode(h.readAll())
end

return ccdb
