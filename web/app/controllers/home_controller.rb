require 'test_runner'

class HomeController < ApplicationController

  def initialize()
    super()
  end

  def index
    testModules = TestRunner.instance.getTestModuleList()
    render "home/index", :locals => {testModuleList: testModules}
  end

  def dotest
    testInst = TestRunner.instance.runTest(params[:testModule], params[:url])
    render "home/dotest", locals: params.merge({
      testUUID: testInst.uuid,
      })
  end

  def updateTestStatus
    isComplete = TestRunner.instance.testComplete?(params[:uuid])
    nextLine = ""
    isSuccess = isComplete && TestRunner.instance.testSuccess?(params[:uuid])
    if !isComplete
      begin
        nextLine = TestRunner.instance.getAvailableTestOutput(params[:uuid])
      rescue EOFError => e
        puts e.to_s
      end
    else
      nextLine = TestRunner.instance.getAllTestOutput(params[:uuid])
    end

    render :json => {
      complete: isComplete,
      success: isSuccess,
      line: nextLine
    }
  end

end
