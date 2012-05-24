import os
from setuptools import setup, find_packages

version = '0.1.0'
README = os.path.join(os.path.dirname(__file__), 'README.txt')
long_description = open(README).read() + '\n\n'
setup(name='<+FILENAME+>',
version=version,
description=("<+CURSOR+>"),
long_description=long_description,
classifiers=[
"Programming Language :: Python",
("Topic :: Software Development :: Libraries ::
"Python Modules"),
],
keywords='',
author=<+AUTHOR+>,
author_email=<+EMAIL+>,
license='GPL',
packages=find_packages(),
namespace_packages=[' '],
install_requires=['']
)

