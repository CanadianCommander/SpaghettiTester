import importlib

TEST_MODULE_CLASS_NAME="TestModule"

def get_test_module(moduleName):
    module = importlib.import_module(moduleName)
    testModule = getattr(module, TEST_MODULE_CLASS_NAME)
    return testModule()
