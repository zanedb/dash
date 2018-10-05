class PagesController < ApplicationController
  def index
    #render react_component: 'Home'
  end

  def not_found
    render react_component: 'NotFound'
  end
end
