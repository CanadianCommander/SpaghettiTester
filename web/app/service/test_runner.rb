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
      test == '.' || test == '..' || (/^test.*/ =~ test) == nil
    end
    return testList
  end

  # starts running the test identified by, moduleName and returns an instance of the test
  def runTest(moduleName, url)
    #TODO async + prevent command injection

    #validate input
    if !isInputSafe(moduleName) || !isInputSafe(url)
      raise ArgumentError, 'moduleName or url have invalid characters'
    end

    newTest = TestInstance.new
    #newTest.output = `cd #{getProjectRootPath}; python3 ./run_test.py -u #{url} -t #{TEST_MODULE_DIR}.#{moduleName}`
    _, newTest.output, newTest.thread =
      Open3.popen2e("cd #{getProjectRootPath}; python3 -u ./run_test.py -u \"#{url}\" -t \"#{TEST_MODULE_DIR}.#{moduleName}\"")

    @tests[newTest.uuid] = newTest
    return newTest
  end

  def getTestInstance(uuid)
    return @tests[uuid]
  end

  def getAvailableTestOutput(uuid)
    testInst = @tests[uuid]

    begin
      output = ""
      testInst.output.read_nonblock(8192, output)
      return output
    rescue IO::EAGAINWaitReadable
      return ""
    end
  end

  def getAllTestOutput(uuid)
    testInst = @tests[uuid]
    return testInst.output.read()
  end

  def testComplete?(uuid)
    return @tests[uuid].isDone?
  end

  def testSuccess?(uuid)
    return @tests[uuid].isSuccess?
  end

  private

  def getProjectRootPath()
    return "#{Rails.root}/#{Settings.testRunnerPath}"
  end

  def isInputSafe(inputString)
    # hopefully prevent command injection
    return (/[^a-zA-Z0-9:\/.&\?%=_-]+/ =~ inputString) == nil
  end
end

class TestInstance
  attr_accessor :uuid, :output, :thread, :isDone

  def initialize()
    @uuid = SecureRandom.uuid
    @isDone = false
  end

  def isDone?
    return @thread.status == false || @thread.status == nil
  end

  def isSuccess?
    if isDone?
      return @thread.value == 0
    else
      return false
    end
  end

  def wait
    return @thread.value
  end

end
