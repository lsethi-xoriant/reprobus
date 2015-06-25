class FileLoadHelper
  attr_accessor :int
  attr_accessor :skip
  attr_accessor :val
  attr_accessor :returnStr
  attr_accessor :errstr
  attr_accessor :skipstr

  def setdefaults
    self.int = 0
    self.skip = 0
    self.val = 0
    self.returnStr = ""
    self.errstr = ""
    self.skipstr = ""
  end

  def add_skip_record(skipText)
    self.skip = self.skip + 1 # record alread exists with these details. skip it.
    self.skipstr = self.skipstr + "<br>" + skipText
  end      
  
  def add_validation_record(errText)
    self.val = self.val + 1 # record alread exists with these details. skip it.
    self.errstr = self.errstr + "<br>" + errText
  end   

end