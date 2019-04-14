require 'singleton'

TEST_MODULE_DIR = 'testmodules'

class TestRunner
  include Singleton

  def getTestModuleList()
    testList = Dir.entries(getProjectRootPath() + '/' + TEST_MODULE_DIR)
    testList.delete_if do |test|
      test == '.' || test == '..'
    end
    return testList
  end

  private

  def getProjectRootPath()
    return "#{Rails.root}/#{Settings.testRunnerPath}"
  end
end
