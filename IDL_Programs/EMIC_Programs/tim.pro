Function Tim,Sec
  Hr=Long(Sec)/3600
  Mn=Long(Sec-3600*Hr)/60
  Sc=Sec Mod 60
  Return,String(hr,mn,sc,$
                Format="(I2.2,':',I2.2,':',i2.2)")
end
