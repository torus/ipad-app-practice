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

local doc

function init (width, height)
   print ("init: " .. width .. ", " .. height)

   local ratio = height / width

   size = {width = 10, height = 10 * ratio} -- 10m x ~13.3m
   scale = size.width / width

   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()
   glDisable(GL_DEPTH_TEST)
   glEnable(GL_TEXTURE_2D)
   glEnable(GL_BLEND)
   glBlendFunc(GL_ONE, GL_SRC_COLOR)

   tex1 = gltexture.GLTextureAdapter('11-texture.png')


   print ("b2World: " .. tostring (b2World))
   print ("b2Vec2: " .. tostring (b2Vec2))

   world = b2World(b2Vec2(0, -10), false)

   doc = xmlParseFile (getDir () .. "/11-hashed.xml")

   local root = doc.children
   print ("root: " .. tostring (root))
   local c1 = root.children.next
   print ("c1: " .. tostring (c1))

   local n = c1.name
   print ("n: " .. tostring (n))
   local t = c1.type
   print ("t: " .. tostring (t))

   print "init done"
end

function draw ()
   glClearColor(1, 1, 1, 1)
   glClear(GL_COLOR_BUFFER_BIT)

   glMatrixMode(GL_PROJECTION)
   glLoadIdentity()
   glOrthof (0, size.width, 0, size.height, -1, 1)

   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()

   glEnableClientState(GL_VERTEX_ARRAY)
   glEnableClientState(GL_TEXTURE_COORD_ARRAY)

   glPushMatrix ()
   glTranslatef(0, 0, 0.0)
   glScalef (scale, scale, 1)
   tex1:drawInRect(0, 0, 0, 0, 0, 32, 32)
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
