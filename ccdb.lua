---
-- CCDB Client β0.3
-- (c) 2017 neverclear
-- @author neverclear
--

-- json.lua Copyright (c) 2015 rxi
local json = loadstring(http.get("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua").readAll())()
--------------------------------------------------------------------------------------
local url = "http://localhost:55440"
local api = "/api"

local ccdb = {}

--- グローバルユーザ名
local username = nil
--- グローバルパスワード
local password = nil


---
-- データベースURLを取得
-- @return URL
function ccdb.getUrl()
  return url
end

---
-- データベースURLを設定
-- @param u URL
function ccdb.setUrl(u)
  url = u
end
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

local error = {
  result = false,
  detail = {
    name = "ConnectionError",
    message = "Connection to server failed."
  }
}

local function getResponse(h)
  if h then
    return json.decode(h.readAll())
  else
    return error
  end
end

local function get(url, header)
  return getResponse(http.get(url, header))
end

local function post(url, params, header)
  return getResponse(http.post(url, params, header))
end

---
-- テーブルをパラメータへ変換する
-- @param data テーブル
-- @return パラメータ文字列
local function toParam(data)
  local paramStr = ""
  for k, v in pairs(data) do
    paramStr = paramStr .. k .. "=" .. v .. "&"
  end
  return string.sub(paramStr, 1, -2)
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

---
-- " > num"　大なりオペレータ生成
-- @param       num     比較する数値
-- @param[opt]  isEqual true: >=
-- @return              大なりオペレータ
function ccdb.gt(num, isEqual)
  local op = "$gt"
  if isEqual then
    op = op .. "e"
  end
  return {[op] = num}
end

---
-- ">= num"  以上のオペレータ生成
-- @param num 比較する数値
-- @return    以上オペレータ
function ccdb.gte(num)
  return ccdb.gt(num, true)
end

---
-- " < num"　小なりオペレータ生成
-- @param       num     比較する数値
-- @param[opt]  isEqual true: <=
-- @return              小なりオペレータ
function ccdb.lt(num, isEqual)
  local op = "$lt"
  if isEqual then
    op = op .. "e"
  end
  return {[op] = num}
end
---
-- "<= num"  以下のオペレータ生成
-- @param num 比較する数値
-- @return    以下オペレータ
function ccdb.lte(num)
  return ccdb.lt(num, true)
end

---
-- "!=" NotEqualオペレータ生成
-- @param data  比較データ
-- @return      NotEqualオペレータ
function ccdb.not(data)
  return {["$ne"] = data}
end

---
-- "in(...)" inオペレータ生成 (or)
-- @param ... データリスト
-- @return    inオペレータ
function ccdb.in(...)
  return {["$in"] = {...}}
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
  local h = http.post(url .. api .. "/user/insert/", param)
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
  local h = http.post(url .. api .. "/user/update/", param)
  return json.decode(h.readAll())
end

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
  return get(url .. api .. "/db/find/?" .. param)
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
  return post(url .. api .. "/db/insert/", param)
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

  return post(url .. api .. "/db/update/", param)
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

  return post(url .. api .. "/db/delete/", param)
end

return ccdb
