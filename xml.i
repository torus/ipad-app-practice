// use SWIG version >= 1.3.40

%module dom

%{
  #include <libxml/tree.h>
  #include <stdio.h>
%}

%native(nullNs) int getNullNs (lua_State *L);

%{
  int getNullNs (lua_State *L)
  {
    lua_pushlightuserdata (L, NULL);
    return 1;
  }
%}

%typemap(in) xmlChar* {
  $1 = (xmlChar*) (lua_tostring (L, $input));
}

%typemap(in) xmlNs* {
  $1 = (xmlNs*) (lua_topointer (L, $input));
}

%typemap(out) xmlChar* {
  lua_pushstring (L, (const char*)$1);
}

%typemap(in, numinputs=0) (xmlChar ** mem, int * size) (xmlChar *temp, int templen) {
  $1 = &temp;
  $2 = &templen;
}

%typemap(argout) (xmlChar ** mem, int * size) {
  // Append output value $1 to $result
  lua_pushlstring (L, (const char*)*$1, *$2);
  SWIG_arg ++;
}


%include </usr/include/libxml2/libxml/xmlexports.h>
%include </usr/include/libxml2/libxml/xmlversion.h>
%include </usr/include/libxml2/libxml/tree.h>
