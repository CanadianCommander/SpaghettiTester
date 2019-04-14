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
    render "home/dotest", locals: params.merge({output: testInst.output})
  end
end
