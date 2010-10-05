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
local body

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

        -- CGSize size = CGSizeMake(10, 10);
        -- printf("w: %f, h: %f\n", size.width, size.height);
   world = b2World(b2Vec2(0, -10), false)

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
   ;
   (function ()
       local bodyDef = b2BodyDef ()
       bodyDef.type = b2_dynamicBody
       bodyDef.position:Set(5.0, 9.0)
       body = world:CreateBody(bodyDef)
            
       local dynamicBox = b2PolygonShape ()
       dynamicBox:SetAsBox(1.0, 1.0)
            
       local fixtureDef = b2FixtureDef ()
       fixtureDef.shape = dynamicBox
       fixtureDef.density = 1.0
       fixtureDef.friction = 0.3
            
       body:CreateFixture(fixtureDef)
    end) ()

   print "init done"
end

function draw ()
   -- print ("draw")
   -- print (tostring (tex1))

    -- glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    -- glViewport(0, 0, backingWidth, backingHeight);

   local timeStep = 1.0 / 30.0
   local velocityIterations = 6
   local positionIterations = 2
   world:Step(timeStep, velocityIterations, positionIterations)
    
   world:ClearForces()
   local position = body:GetPosition()

   glMatrixMode(GL_PROJECTION)
   glLoadIdentity()
   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()

   glTranslatef((position.x - 5) / 10.0, (position.y - 5) / 10.0, 0.0)

   glClearColor(0, 0, 0, 1)
   glClear(GL_COLOR_BUFFER_BIT)


   glEnableClientState(GL_VERTEX_ARRAY)
   glEnableClientState(GL_TEXTURE_COORD_ARRAY)

   tex1:draw(0, 0, 0, 0.005)

   glDisableClientState(GL_VERTEX_ARRAY)
   glDisableClientState(GL_TEXTURE_COORD_ARRAY)

    -- print "draw done"
end
