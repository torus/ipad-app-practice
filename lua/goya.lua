local tex1

local x = getfenv ()
print (tostring (x))
local m = getmetatable (x) or {}
print (tostring (m))
m.__index = gl
setmetatable (x, m)
print (tostring (glMatrixMode))
print (tostring (GL_MODELVIEW))

function init ()
   print ("init")

   glMatrixMode(GL_MODELVIEW)
   glLoadIdentity()
   glDisable(GL_DEPTH_TEST)
   glEnable(GL_TEXTURE_2D)
   glEnable(GL_BLEND)
   glBlendFunc(GL_ONE, GL_SRC_COLOR)

   tex1 = gltexture.GLTextureAdapter('goya.jpg')
end

function draw ()
   -- print ("draw")
   -- print (tostring (tex1))

    -- glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    -- glViewport(0, 0, backingWidth, backingHeight);

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()

    -- glTranslatef((position.x - 5) / 10.0, (position.y - 5) / 10.0, 0.0f);

    glClearColor(0, 0, 0, 1)
    glClear(GL_COLOR_BUFFER_BIT)


    glEnableClientState(GL_VERTEX_ARRAY)
    glEnableClientState(GL_TEXTURE_COORD_ARRAY)

    tex1:draw(0, 0, 0, 0.005)

    glDisableClientState(GL_VERTEX_ARRAY)
    glDisableClientState(GL_TEXTURE_COORD_ARRAY)

    -- print "draw done"
end
