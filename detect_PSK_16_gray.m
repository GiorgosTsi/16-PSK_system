function [est_X, est_bit_seq] = detect_PSK_16_gray(Y)
    for j = 1:length(Y)
        for m = 1:16
            nearest_neighbor(m) = sqrt(((Y(j,1) - cos((2*pi*(m-1))/16))^2) + ((Y(j,2) - sin((2*pi*(m-1))/16))^2));
        end
        minNeighbor = min(nearest_neighbor);
        for i = 1:16
            if minNeighbor == nearest_neighbor(i)
                k = i;
            end
        end
        est_X(1,j) = cos(2*pi*(k-1)/16);
        est_X(2,j) = sin(2*pi*(k-1)/16);
    end
    
    j = 1;
    for i = 1:4:4*length(Y)
        if est_X(1,j) == cos(2*pi*0/16) && est_X(2,j) == sin(2*pi*0/16)
            % 0000 => X0
            est_bit_seq(i:i+3,1) = [0; 0; 0; 0];

        elseif est_X(1,j) == cos(2*pi*1/16) && est_X(2,j) == sin(2*pi*1/16)
            % 0001 => X1
            est_bit_seq(i:i+3,1) = [0; 0; 0; 1];

        elseif est_X(1,j) == cos(2*pi*2/16) && est_X(2,j) == sin(2*pi*2/16)
            % 0011 => X2
            est_bit_seq(i:i+3,1) = [0; 0; 1; 1];

        elseif est_X(1,j) == cos(2*pi*3/16) && est_X(2,j) == sin(2*pi*3/16)
            % 0010 => X3
            est_bit_seq(i:i+3,1) = [0; 0; 1; 0];

        elseif est_X(1,j) == cos(2*pi*4/16) && est_X(2,j) == sin(2*pi*4/16)
            % 0110 => X4
            est_bit_seq(i:i+3,1) = [0; 1; 1; 0];

        elseif est_X(1,j) == cos(2*pi*5/16) && est_X(2,j) == sin(2*pi*5/16)
            % 0111 => X5
            est_bit_seq(i:i+3,1) = [0; 1; 1; 1];

        elseif est_X(1,j) == cos(2*pi*6/16) && est_X(2,j) == sin(2*pi*6/16)
            % 0101 => X6
            est_bit_seq(i:i+3,1) = [0; 1; 0; 1];

        elseif est_X(1,j) == cos(2*pi*7/16) && est_X(2,j) == sin(2*pi*7/16)
            % 0100 => X7
            est_bit_seq(i:i+3,1) = [0; 1; 0; 0];

        elseif est_X(1,j) == cos(2*pi*8/16) && est_X(2,j) == sin(2*pi*8/16)
            % 1010 => X8
            est_bit_seq(i:i+3,1) = [1; 0; 1; 0];

        elseif est_X(1,j) == cos(2*pi*9/16) && est_X(2,j) == sin(2*pi*9/16)
            % 1011 => X9
            est_bit_seq(i:i+3,1) = [1; 0; 1; 1];

        elseif est_X(1,j) == cos(2*pi*10/16) && est_X(2,j) == sin(2*pi*10/16)
            % 1001 =>X10
            est_bit_seq(i:i+3,1) = [1; 0; 0; 1];

        elseif est_X(1,j) == cos(2*pi*11/16) && est_X(2,j) == sin(2*pi*11/16)
            % 1000 => X11
            est_bit_seq(i:i+3,1) = [1; 0; 0; 0];

        elseif est_X(1,j) == cos(2*pi*12/16) && est_X(2,j) == sin(2*pi*12/16)
            % 1100 => X12
            est_bit_seq(i:i+3,1) = [1; 1; 0; 0];

        elseif est_X(1,j) == cos(2*pi*13/16) && est_X(2,j) == sin(2*pi*13/16)
            % 1101 => X13
            est_bit_seq(i:i+3,1) = [1; 1; 0; 1];

        elseif est_X(1,j) == cos(2*pi*14/16) && est_X(2,j) == sin(2*pi*14/16)
            % 1111 => X14
            est_bit_seq(i:i+3,1) = [1; 1; 1; 1];

        else
            % 1110 => X15
            est_bit_seq(i:i+3,1) = [1; 1; 1; 0];
        end
        j = j + 1;
    end
end
