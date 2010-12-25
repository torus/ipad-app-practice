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

local tex1
local world
local edge_body
local goya = {}
local joint1
local joint2
local size
local scale
local key_stat = {}

local doc

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

local images

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

function proc ()
   proc_init ("3-texture.png", getDir () .. "/3-compacted.xml")
   -- proc_init ("11-texture.png", getDir () .. "/11-compacted.xml")

   while true do
      if key_stat.swipe_right then
         proc_init ("3-texture.png", getDir () .. "/3-compacted.xml")
      elseif key_stat.swipe_left then
         proc_init ("11-texture.png", getDir () .. "/11-compacted.xml")
      end

      key_stat = {}

      proc_draw ()
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

function proc_init (tex_path, data_path)
   print ("proc_init:", tex_path, data_path)
   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()
   glDisable(GL_DEPTH_TEST)
   glEnable(GL_TEXTURE_2D)
   glEnable(GL_BLEND)
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

   tex1 = gltexture.GLTextureAdapter(tex_path)

   print ("b2World: " .. tostring (b2World))
   print ("b2Vec2: " .. tostring (b2Vec2))

   world = b2World(b2Vec2(0, -10), false)
   images = {}
   doc = xmlParseFile (data_path)

   local root = doc.children
   print ("root: " .. tostring (root))

   local matresult = mat (root)
   print ("matresult: " .. tostring (matresult))

   print "proc_init() done"
end

function draw ()
   coroutine.resume (proc_coroutine)
end

function proc_draw ()
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

   for i, img in ipairs (images) do
      glPushMatrix ()
      glTranslatef(0, 0, i * 0.01 - 10)
      for k, tile in ipairs (img.tiles) do
         local id = tile.id
         local x = id % 32
         local y = (id - x) / 32
         tex1:drawInRect(tile.off_x, 1024 - tile.off_y - 32, 0, x * 32, y * 32, 32, 32)
      end
      glPopMatrix ()
   end

   glPopMatrix ()

   glDisableClientState(GL_VERTEX_ARRAY)
   glDisableClientState(GL_TEXTURE_COORD_ARRAY)
end

function step (timeStep, gravx, gravy)
   -- local timeStep = 1.0 / 30.0
   local velocityIterations = 6
   local positionIterations = 2

   world:SetGravity (b2Vec2 (gravx * 10, gravy * 10))
   world:Step(timeStep, velocityIterations, positionIterations)
   world:ClearForces()
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
