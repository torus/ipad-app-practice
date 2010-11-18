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

   local nx = c1.namex

   -- edge_body = create_edge (world)
   -- table.insert (goya, create_goya (world, 3.0, 9.0))
   -- table.insert (goya, create_goya (world, 7.0, 9.0))

   -- local jd = b2DistanceJointDef ()
   -- jd.frequencyHz = 3
   -- jd.dampingRatio = 0.1
   -- jd.bodyA = goya[1]
   -- jd.bodyB = goya[2]

   -- jd.localAnchorA:Set (0, 0)
   -- jd.localAnchorB:Set (0.1, 0.1)

   -- jd.length = 4

   -- joint1 = world:CreateJoint (jd)

   -- jd.bodyB = edge_body
   -- jd.localAnchorB:Set (5, 10)
   -- joint2 = world:CreateJoint (jd)

   print "init done"
end

-- function create_goya (world, x, y)
--    local bodyDef = b2BodyDef ()
--    bodyDef.type = b2_dynamicBody
--    bodyDef.position:Set(x, y)
--    body = world:CreateBody(bodyDef)
   
--    local dynamicBox = b2PolygonShape ()
--    dynamicBox:SetAsBox(0.5, 0.5)
   
--    local fixtureDef = b2FixtureDef ()
--    fixtureDef.shape = dynamicBox
--    fixtureDef.density = 1.0
--    fixtureDef.friction = 0.3

--    body:CreateFixture(fixtureDef)

--    return body
-- end

-- function create_edge (world)
--    local bodyDef = b2BodyDef ()
--    bodyDef.type = b2_staticBody
--    bodyDef.position:Set(0, 0)
--    local edge_body = world:CreateBody(bodyDef)

--    print ("edge_body: " .. tostring (edge_body))

--    -- local size = {width = 10, height = 10}

--    local wext = size.width / 2
--    local hext = size.height / 2

--    local shapes = {b2PolygonShape (), b2PolygonShape (), b2PolygonShape (), b2PolygonShape ()}

--    shapes[1]:SetAsBox(wext, 1, b2Vec2(wext, -1), 0)
--    shapes[2]:SetAsBox(wext, 1, b2Vec2(wext, size.height + 1), 0)
--    shapes[3]:SetAsBox(1, hext, b2Vec2(-1, hext), 0)
--    shapes[4]:SetAsBox(1, hext, b2Vec2(size.width + 1, hext), 0)

--    for i = 1, 4 do
--       local fixtureDef = b2FixtureDef ()
--       fixtureDef.shape = shapes[i]
--       edge_body:CreateFixture(fixtureDef)
--    end

--    print "edge prepared"

--    return edge_body
-- end

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

   -- for i, g in ipairs (goya) do
   --    draw_goya (g)
   -- end

   -- 768px => 10
   -- 1 = 76.8px

   glPushMatrix ()
   glTranslatef(0, 0, 0.0)
   glScalef (scale, scale, 1)
   tex1:drawInRect(1, 1, 0, 0, 0, 32, 32)
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

-- function add (x, y)
--    table.insert (goya, create_goya (world, x * scale, y * scale))
-- end

-- function draw_goya (g)
--    local position = g:GetPosition()

--    glPushMatrix ()
--    glTranslatef(position.x, position.y, 0.0)
--    tex1:draw(0, 0, 0, 1 / 128)
--    glPopMatrix ()
-- end
