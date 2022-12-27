from libcpp.string cimport string

cdef extern from "base64.hpp":
    cpdef string b64encode(const char*)
    cpdef string b64decode(const char*)
