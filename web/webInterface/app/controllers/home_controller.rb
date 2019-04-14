class HomeController < ApplicationController
  attr_accessor :testModuleNames

  def initialize()
    super()
    #TODO get these from file system 
    @testModuleNames = ["test1", "test2", "test3"]
  end

  def index
  end
end
