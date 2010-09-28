wrapper: GLTextureAdapter_wrap.mm gl_wrap.m

%_wrap.mm: %.i
	swig -c++ -lua -o $@ $<

%_wrap.m: %.i
	swig -lua -o $@ $<

clean:
	rm -f *_wrap.*
