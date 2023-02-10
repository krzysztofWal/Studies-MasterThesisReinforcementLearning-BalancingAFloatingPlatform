function [] = restart_python()
	terminate(pyenv)
    if ispc
        insert(py.sys.path,int32(0),'C:\Program Files\MATLAB\R2021b\extern\engines\python\build\lib')
    else
	    insert(py.sys.path,int32(0),'/home/krzysztof/matlab/extern/engines/python/build/lib/')
    end
    pyrun("import py_mod_")

%     mod_ = py.importlib.import_module('py_mod_')
%     py.importlib
end