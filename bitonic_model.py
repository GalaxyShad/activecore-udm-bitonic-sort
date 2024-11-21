# alg model - python math can be used here 
def sort_python_std(x): 
    y = x[:] 
    y.sort() 
    return y 
 
# hw model - synthesizable operations only 
def sort_asc(x, i_a, i_b): 
    if x[i_a] > x[i_b]: 
        x[i_a], x[i_b] = x[i_b], x[i_a] 
 
def sort_bitonic_8_hw(x): 
    # array copy 
    y = x[:]  
     
    # ========================= 
    # stage 1 
    # ========================= 
    sort_asc(y, 0, 1) # ->  
    sort_asc(y, 3, 2) # <- 
    sort_asc(y, 4, 5) # -> 
    sort_asc(y, 7, 6) # <-  
         
    # ========================= 
    # stage 2 
    # ========================= 
    sort_asc(y, 0, 2) # -> 
    sort_asc(y, 1, 3) # -> 
    sort_asc(y, 6, 4) # <- 
    sort_asc(y, 7, 5) # <- 
     
    sort_asc(y, 0, 1) # -> 
    sort_asc(y, 2, 3) # -> 
    sort_asc(y, 5, 4) # <- 
    sort_asc(y, 7, 6) # <- 
         
    # ========================= 
    # stage 3 
    # ========================= 
    sort_asc(y, 0, 4) # -> 
    sort_asc(y, 1, 5) # -> 
    sort_asc(y, 2, 6) # -> 
    sort_asc(y, 3, 7) # -> 
     
    sort_asc(y, 0, 2) # -> 
    sort_asc(y, 1, 3) # -> 
    sort_asc(y, 4, 6) # -> 
    sort_asc(y, 5, 7) # -> 
     
    sort_asc(y, 0, 1) # -> 
    sort_asc(y, 2, 3) # -> 
    sort_asc(y, 4, 5) # -> 
    sort_asc(y, 6, 7) # -> 
     
    # ========================= 
     
    return y 
 
# generating test stimulus 
 
x = [51, 160, 1004, 77, 194, 223, 13, 84] 
# x = [9, 7, 5, 3, 8, 2, 1, 6] 
 
y_alg = sort_python_std(x) 
y_hw = sort_bitonic_8_hw(x) 
 
for index in range(0, 8): 
    if (y_alg[index] == y_hw[index]): 
        print("Correct! index: ", hex(index).ljust(6), " y: ", hex(y_hw[index]).ljust(6)) 
    else: 
        print("ERROR! index: ", hex(index).ljust(6), " y(model): ", hex(y_alg[index]).ljust(6), " y(hw): ", hex(y_hw[index]).ljust(6)) 
 
 
print("Hadware Test") 
 
from designs.rtl.udm.sw.udm import * 
 
udm = udm('COM7', 921600) 
print("") 
 
CSR_INPUT_ADR = 0x10 
CSR_OUTPUT_ADR = 0x18 
 
for index in range(0, 8): 
    udm.wr32(CSR_INPUT_ADR + index, x[index])      
print("") 
 
for index in range(0, 8): 
    print(udm.rd32(CSR_OUTPUT_ADR + index)) 
 
udm.disconnect()
