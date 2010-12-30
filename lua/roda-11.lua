local x = getfenv ()
print (tostring (x))
local m = getmetatable (x) or {}
print (tostring (m))

m.__index = function (tbl, key)
               return gl[key] or b2[key] or xml[key]
            end

print (tostring (xml))

setmetatable (x, m)

print (tostring (glMatrixMode))
print (tostring (GL_MODELVIEW))

local size
local scale
local key_stat = {}
local step_stat = {}

function M (name, ...)
   local preds = {...}
   return function (elem)
             -- print ("M: eating " .. name)
             local targetname = elem.type == XML_TEXT_NODE and "#text" or elem.name

             if targetname == name then
                for i, pred in ipairs (preds) do
                   if not pred (elem) then
                      return false
                   end
                end
                return true
             else
                return false
             end
          end
end

function C (...)
   local preds = {...}
   return function (elem)
             local ch = elem.children

             while ch do
                local res = (function ()
                                for i, pred in ipairs (preds) do
                                   if type (pred) == "string" then
                                      local name = pred
                                      pred = function (ch)
                                                return name == ch.name
                                             end
                                   end
                                   if pred (ch) then
                                      return true
                                   end
                                end
                                return false
                             end) ()
                if not res then
                   return false
                end
                ch = ch.next
             end
             return true
          end
end

function extract_page_data (images)
   assert (type (images) == "table")

   local mat =
      M ("images",
         C (M ("#text"),
            M ("image",
               function (e)
                  local w = xmlGetProp (e, "width")
                  local h = xmlGetProp (e, "height")

                  local img = {name = e.name, width = w, height = h, tiles = {}}
                  print (img.name, img.width, img.height)

                  local res = C (M ("#text"),
                                 M ("tile",
                                    function (e)
                                       local t = {
                                          id = tonumber (xmlGetProp (e, "id")),
                                          w = tonumber (xmlGetProp (e, "width")),
                                          h = tonumber (xmlGetProp (e, "height")),
                                          off_x = tonumber (xmlGetProp (e, "offset-x")) - 32,
                                          off_y = tonumber (xmlGetProp (e, "offset-y")) - 32,
                                       }
                                       table.insert (img.tiles, t)
                                       return true
                                    end)) (e)
                  if res then
                     table.insert (images, img)
                     return true
                  else
                     return false
                  end
               end)))
   return mat
end

function read_page_data (data_path)
   local images = {}
   local doc = xmlParseFile (getDir () .. "/" .. data_path)

   local root = doc.children
   print ("root: " .. tostring (root))

   local matresult = extract_page_data (images) (root)
   print ("matresult: " .. tostring (matresult))

   return images
end

function load_page_helper (n)
   local images = read_page_data (string.format ("%d-compacted.xml", n))
   local tiles = images[#images].tiles
   local numtile = tiles[#tiles].id

   print ("load_page_helper", n, images, tiles, numtile)

   if numtile > 32 * 32 then
      local mod = numtile % (32 * 32)
      local numtex = (numtile - mod) / (32 * 32)
      assert (numtex > 0)
      local dest = {}
      for i = 0, numtex do
         table.insert (dest, string.format ("%d-texture-%d.png", n, i))
      end
      print ("load_page_helper", n, unpack (dest))
      return dest, images
   else
      return {string.format ("%d-texture.png", n)}, images
   end
end

function proc ()
   proc_init ()

   local page3 = load_page (load_page_helper (5))
   -- local page3 = load_page ({"5-texture-0.png", "5-texture-1.png"}, read_page_data ("5-compacted.xml"))

   local page11
   local page = page3

   local world = b2World(b2Vec2(0, -10), false)

   while true do
      if key_stat.swipe_right then
         page = page3
      elseif key_stat.swipe_left then
         if not page11 then
            page11 = load_page (load_page_helper (19))
            -- page11 = load_page ("19-texture.png", read_page_data ("19-compacted.xml"))
         end
         page = page11
      end

      -- local timeStep = 1.0 / 30.0
      local velocityIterations = 6
      local positionIterations = 2

      if step_stat.gravity then
         local gravx, gravy = unpack (step_stat.gravity)
         world:SetGravity (b2Vec2 (gravx * 10, gravy * 10))
      else
         print ("NO step_stat.gravity")
      end
      if step_stat.time_step then
         world:Step(step_stat.time_step, velocityIterations, positionIterations)
      else
         print ("NO time_step")
      end
      world:ClearForces()

      key_stat = {}

      proc_draw (page)
      coroutine.yield ()
   end
end

local proc_coroutine = coroutine.create (proc)

function init (width, height)
   print ("init: " .. width .. ", " .. height)

   local ratio = height / width

   size = {width = 10, height = 10 * ratio} -- 10m x ~13.3m
   scale = size.width / width

   print "init done"
end

function proc_init ()
   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()
   glDisable(GL_DEPTH_TEST)
   glEnable(GL_TEXTURE_2D)
   glEnable(GL_BLEND)
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

   print "proc_init() done"
end

function load_page (tex_path, images)
   print ("load_page:", tex_path, data_path)

   -- local images = {}
   -- local doc = xmlParseFile (data_path)

   -- local root = doc.children
   -- print ("root: " .. tostring (root))

   -- local matresult = extract_page_data (images) (root)
   -- print ("matresult: " .. tostring (matresult))

   local tex = {}
   if type (tex_path) == "string" then
      tex_path = {tex_path}
   end

   assert (type (tex_path) == "table")

   for i, path in ipairs (tex_path) do
      table.insert (tex, gltexture.GLTextureAdapter(path))
   end

   return {tex = tex, images = images}
end

function draw ()
   coroutine.resume (proc_coroutine)
end

function proc_draw (page)
   local tex, images = page.tex, page.images
   local proc = page.proc or
      function ()
         for i, img in ipairs (images) do
            glPushMatrix ()
            glTranslatef(0, 0, i * 0.01 - 10)
            for k, tile in ipairs (img.tiles) do
               local id = tile.id
               local id_l = id % (32 * 32)
               local texn = (id - id_l) / (32 * 32)
               local x = id_l % 32
               local y = ((id_l - x) / 32) % 32
               -- print (string.format ("id: %d, id_l: %d, texn: %d, x: %d, y: %d", id, id_l, texn, x, y))
               tex[texn + 1]:drawInRect(tile.off_x, 1024 - tile.off_y - 32, 0, x * 32, y * 32, 32, 32)
            end
            glPopMatrix ()
         end
      end

   glClearColor(0.3, 0.3, 0.3, 1)
   glClear(GL_COLOR_BUFFER_BIT)

   glMatrixMode(GL_PROJECTION)
   glLoadIdentity()
   glOrthof (0, size.width, 0, size.height, 0, 100)

   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()

   glEnableClientState(GL_VERTEX_ARRAY)
   glEnableClientState(GL_TEXTURE_COORD_ARRAY)

   glPushMatrix ()
   glScalef (scale, scale, 1)
   glTranslatef(0, 0, 0)

   proc ()

   glPopMatrix ()

   glDisableClientState(GL_VERTEX_ARRAY)
   glDisableClientState(GL_TEXTURE_COORD_ARRAY)
end

function step (timeStep, gravx, gravy)
   step_stat.gravity = {gravx, gravy}
   step_stat.time_step = timeStep
end

function touch (x, y)
   print ("touch", x, y)

   key_stat.touch = {x, y}
end

function swipeRight ()
   print ("swipeRight")

   key_stat.swipe_right = true
end

function swipeLeft ()
   print ("swipeLeft")

   key_stat.swipe_left = true
end
