PRO class1::Print
    PRINT, self.data1
END
PRO class2::Print
    self -> class1::Print
    PRINT, self.data2a, self.data2b
END

PRO test_OBJ
struct = {class1, data1}

struct = { class2, data2a:0, data2b:0.0, inherits class1 }
struct = { class3, data3:'', inherits class2, inherits class1 }
struct = { class4, data4:0L, inherits class2, inherits class3 }

A = OBJ_NEW('class4')

A -> Print
end