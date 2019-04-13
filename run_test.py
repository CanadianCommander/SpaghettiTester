from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from pkg.moduleUtil import get_test_module
import argparse
import sys
import importlib

GECKO_DRIVER_PATH=r'vendor/geckodriver'

def parse_cli_args():
    argparser = argparse.ArgumentParser(description="automated web testing program")

    argparser.add_argument("-u", "--url", type=str, required=True, help="the url at which to start testing")
    argparser.add_argument("-t", "--test", type=str, required=True, help="the testing module to run")

    return argparser.parse_args()

def build_web_driver():
    options = Options()
    options.headless = True
    driver = webdriver.Firefox(options=options, executable_path=GECKO_DRIVER_PATH)
    return driver

if __name__ == "__main__":
    cliArguements = parse_cli_args()
    try:
        webDriver = build_web_driver()
        webDriver.get(cliArguements.url)
        testModule = get_test_module(cliArguements.test)
        sys.exit(testModule.run(webDriver, cliArguements.url))
    except Exception as e:
        print("Error " + str(e))
        sys.exit(1)
    finally:
        if 'webDriver' in locals():
            webDriver.quit()
