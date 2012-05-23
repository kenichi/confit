require 'confit'

module Kernel

  def confit(*args, &block)
    Confit::confit(*args, &block)
  end

end
