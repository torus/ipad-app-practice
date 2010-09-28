wrapper: GLTextureAdapter_wrap.mm gl_wrap.m Box2D_wrap.mm

%_wrap.mm: %.i
	swig -IClasses -c++ -lua -o $@ $<

%_wrap.m: %.i
	swig -lua -o $@ $<

clean:
	rm -f *_wrap.*
