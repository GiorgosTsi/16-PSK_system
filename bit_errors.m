function num_of_bit_errors =  bit_errors(est_bit_seq,bit_seq)
num_of_bit_errors=0;
    for i=1:length(bit_seq)
       if  est_bit_seq(i) ~= bit_seq(i)    
         num_of_bit_errors=num_of_bit_errors+1;
       end
    end                  
end