function reload_py()
    warning('off','MATLAB:ClassInstanceExists')
    clear classes
    mod = py.importlib.import_module('py_mod_');
    py.importlib.reload(mod);
end