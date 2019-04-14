from selenium.webdriver.common.by import By
import re

class TestModule:
    def run(self, driver, url):
        print("title: %s" % driver.title)

        buildInfoElement = driver.find_element(By.ID, "buildInfo")
        print(buildInfoElement.text)

        if re.search("[Jj]uno", buildInfoElement.text) is not None:
            print ("JUNO! <3")
            return 0
        else:
            return 1
        
