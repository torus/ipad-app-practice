local tex1

function init ()
   print ("init")
   tex1 = gltexture.GLTextureAdapter('goya.jpg')
end

function draw ()
   print ("draw")
   print (tostring (tex1))
   tex1:draw(0, 0, 0, 0.005)
end
