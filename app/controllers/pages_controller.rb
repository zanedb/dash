class PagesController < ApplicationController
  def index
    render react_component: 'Home'
  end
end
