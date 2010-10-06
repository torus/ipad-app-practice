local x = getfenv ()
print (tostring (x))
local m = getmetatable (x) or {}
print (tostring (m))
m.__index = function (tbl, key)
               return gl[key] or b2[key]
            end
setmetatable (x, m)
print (tostring (glMatrixMode))
print (tostring (GL_MODELVIEW))

local tex1
local world
local edge_body
local body1
local body2
local joint1
local joint2

function init ()
   print ("init")

   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()
   glDisable(GL_DEPTH_TEST)
   glEnable(GL_TEXTURE_2D)
   glEnable(GL_BLEND)
   glBlendFunc(GL_ONE, GL_SRC_COLOR)

   tex1 = gltexture.GLTextureAdapter('goya.jpg')


   print ("b2World: " .. tostring (b2World))
   print ("b2Vec2: " .. tostring (b2Vec2))

   world = b2World(b2Vec2(0, -10), false)

   edge_body = create_edge (world)
   body1 = create_goya (world, 3.0, 9.0)
   body2 = create_goya (world, 7.0, 9.0)

   print ("body1 = " .. tostring (body1))
   print ("body2 = " .. tostring (body2))

   local jd = b2DistanceJointDef ()
   jd.frequencyHz = 10
   jd.dampingRatio = 0.5
   jd.bodyA = body1
   jd.bodyB = body2

   jd.localAnchorA:Set (0, 0)
   jd.localAnchorB:Set (0.1, 0.1)

   jd.length = 1

   joint1 = world:CreateJoint (jd)

   print "init done"
end

function create_goya (world, x, y)
   local bodyDef = b2BodyDef ()
   bodyDef.type = b2_dynamicBody
   bodyDef.position:Set(x, y)
   body = world:CreateBody(bodyDef)
   
   local dynamicBox = b2PolygonShape ()
   dynamicBox:SetAsBox(1.0, 1.0)
   
   local fixtureDef = b2FixtureDef ()
   fixtureDef.shape = dynamicBox
   fixtureDef.density = 1.0
   fixtureDef.friction = 0.3

   body:CreateFixture(fixtureDef)

   return body
end

function create_edge (world)
   local bodyDef = b2BodyDef ()
   bodyDef.type = b2_staticBody
   bodyDef.position:Set(0, 0)
   local edge_body = world:CreateBody(bodyDef)

   print ("edge_body: " .. tostring (edge_body))

   local size = {width = 10, height = 10}

   local wext = size.width / 2
   local hext = size.height / 2

   local shapes = {b2PolygonShape (), b2PolygonShape (), b2PolygonShape (), b2PolygonShape ()}

   shapes[1]:SetAsBox(wext, 1, b2Vec2(wext, -1), 0)
   shapes[2]:SetAsBox(wext, 1, b2Vec2(wext, size.height + 1), 0)
   shapes[3]:SetAsBox(1, hext, b2Vec2(-1, hext), 0)
   shapes[4]:SetAsBox(1, hext, b2Vec2(size.width + 1, hext), 0)

   for i = 1, 4 do
      local fixtureDef = b2FixtureDef ()
      fixtureDef.shape = shapes[i]
      edge_body:CreateFixture(fixtureDef)
   end

   print "edge prepared"

   return edge_body
end

function draw ()
   local timeStep = 1.0 / 30.0
   local velocityIterations = 6
   local positionIterations = 2

   world:Step(timeStep, velocityIterations, positionIterations)
   world:ClearForces()

   glClearColor(0, 0, 0, 1)
   glClear(GL_COLOR_BUFFER_BIT)

   draw_goya (body1)
   draw_goya (body2)
end

function draw_goya (goya)
   local position = goya:GetPosition()

   glMatrixMode(GL_PROJECTION)
   glLoadIdentity()
   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()

   glTranslatef((position.x - 5) / 10.0, (position.y - 5) / 10.0, 0.0)

   glEnableClientState(GL_VERTEX_ARRAY)
   glEnableClientState(GL_TEXTURE_COORD_ARRAY)

   tex1:draw(0, 0, 0, 0.001)

   glDisableClientState(GL_VERTEX_ARRAY)
   glDisableClientState(GL_TEXTURE_COORD_ARRAY)
end
