require 'singleton'
require 'open3'

TEST_MODULE_DIR = 'testmodules'

class TestRunner
  include Singleton

  def initialize()
    super()
    @tests = {}
  end

  def getTestModuleList()
    testList = Dir.entries("#{getProjectRootPath()}/#{TEST_MODULE_DIR}")
    testList.delete_if do |test|
      test == '.' || test == '..'
    end
    return testList
  end

  # starts running the test identified by, moduleName and returns an instance of the test
  def runTest(moduleName, url)
    #TODO async + prevent command injection 
    newTest = TestInstance.new(SecureRandom.uuid)
    newTest.output = `cd #{getProjectRootPath}; python3 ./run_test.py -u #{url} -t #{TEST_MODULE_DIR}.#{moduleName}`
    @tests[newTest.uuid] = newTest
    return newTest
  end

  private

  def getProjectRootPath()
    return "#{Rails.root}/#{Settings.testRunnerPath}"
  end
end

class TestInstance
  attr_accessor :uuid, :output, :isDone, :isSuccess

  def initialize(uuid)
    @uuid = uuid
    @isDone = false
    @isSuccess = false
  end

end
