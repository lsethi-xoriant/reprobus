class FileLoadHelper
  attr_accessor :int
  attr_accessor :skip
  attr_accessor :val
  attr_accessor :up
  attr_accessor :returnStr
  attr_accessor :errstr
  attr_accessor :skipstr
  attr_accessor :upstr
  
  def setdefaults
    self.int = 0
    self.skip = 0
    self.val = 0
    self.up = 0
    self.returnStr = ""
    self.errstr = ""
    self.skipstr = ""
    self.upstr = ""
  end

  def add_skip_record(skipText)
    self.skip = self.skip + 1 
    self.skipstr = self.skipstr + "<br>" + skipText
  end      
  
  def add_validation_record(errText)
    self.val = self.val + 1 
    self.errstr = self.errstr + "<br>" + errText
  end   
  
  def add_update_record(upText)
    self.up = self.up + 1 
    self.upstr = self.upstr + "<br>" + upText
  end  
end