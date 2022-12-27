from setuptools import setup, Extension
from Cython.Build import cythonize

ext = [Extension('b64', ['b64.pyx'], language='c++')]
setup(
    name='b64',
    ext_modules=cythonize(ext, compiler_directives={'language_level' : "3"}),
)
