print("HTTP/1.1 200 Internal OK\n\n")
local last_dirname = ""
local last_moddir = 0

local function getLastModification(config)
   local b,c,h = fa.request{
    url = config.host .. "/last_modification?device=" .. config.device
  }
  return tonumber(b)
end

local function uploadImage(config, file_path, modification)
  --get the size of the file
  local filesize = lfs.attributes(file_path,"size")
  if filesize ~= nil then
    print("Uploading "..file_path.." size: "..filesize)
  else
    print("Failed to find "..file_path.."... something wen't wrong!")
    return
  end

  --Upload!
  local boundary = "--61141483716826"
  local contenttype = "multipart/form-data; boundary=" .. boundary
  local mes = "--"..boundary.."\r\n"
   .."Content-Disposition: form-data; name=\"device\"\r\n"
   .."\r\n"
   ..config.device.."\r\n"
   .."--"..boundary.."\r\n"
   .."Content-Disposition: form-data; name=\"modification\"\r\n"
   .."\r\n"
   ..modification.."\r\n"
   .."--"..boundary.."\r\n"
   .."Content-Disposition: form-data; name=\"file\"; filename=\""..file_path.."\"\r\n"
   .."Content-Type: text/plain\r\n"
   .."\r\n"
   .."<!--WLANSDFILE-->\r\n"
   .."--"..boundary.."--\r\n"

   local blen = filesize + string.len(mes) - 17
   local b,c,h = fa.request{
    url=config.host .. "/upload",
    method="POST",
    headers={
      ["Content-Length"]=tostring(blen),
      ["Content-Type"]=contenttype,
    },
    file=file_path,
    body=mes,
    bufsize=1460*10,
  }
  print(c)
  print(b)
  return b
end

local function checkWlanLink()
  for i = 1, 10 do
    local result = fa.WlanLink()
    if result == 1 then
      return 1
    end
    sleep(1000 * i)
  end
  return 0
end

local result = checkWlanLink()
if result ~= 1 then
  print('Failed linking to Wi-fi')
  return
end
print('Linked to Wi-fi')

--read config
local file = io.open('credentials.json')
local text = file:read("*a")
file:close()
local config = cjson.decode(text)

local last_modification = getLastModification(config)

print('Last Modification on server: '..last_modification)

local fpath = config.target_dir
for dirname in lfs.dir(fpath) do
  local dirpath = fpath .. "/" .. dirname
  local mod_dir = lfs.attributes( dirpath, "mode" )
  if mod_dir == "directory" then
    local dir_modifficate = lfs.attributes( dirpath, "modification" )
    if dir_modifficate > last_moddir then
      last_moddir = dir_modifficate
      last_dirname = dirpath
    end
  end
end

local files = {}

for filename in lfs.dir(last_dirname) do
  if(string.sub(filename, 1, 1) ~= ".") then
    local filepath = last_dirname .. "/" .. filename
    local mod = lfs.attributes( filepath, "modification" )
    if mod > last_modification then
      table.insert(files, {filepath=filepath, mod=mod})
    end
  end
end

for i, f in pairs(files) do
  print('Uploading: '..f['filepath']..' '..f['mod'])
  uploadImage(config, f['filepath'], f['mod'])
end
