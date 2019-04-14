require 'test_runner'

class HomeController < ApplicationController

  def initialize()
    super()
  end

  def index
    testModules = TestRunner.instance.getTestModuleList()
    render "home/index", :locals => {testModuleList: testModules}
  end
end
