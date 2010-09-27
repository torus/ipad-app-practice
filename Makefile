wrapper: GLTextureAdapter_wrap.mm

%_wrap.mm: %.i
	swig -c++ -lua -o $@ $<

clean:
	rm -f *_wrap.mm
