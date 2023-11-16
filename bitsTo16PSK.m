function X = bits_to_PSK_16(bit_seq)
    num_symbols = floor(length(bit_seq)/4); % Number of 16PSK symbols

    X = zeros(2, num_symbols); % Initialize symbol matrix
    %%The following modulation follows the above gray encoding:
    % 0000 -> 0 radians      X0 
    % 0001 -> π/8 radians    X1 
    % 0011 -> π/4 radians    X2 
    % 0010 -> 3π/8 radians   X3 
    % 0110 -> π/2 radians    X4
    % 0111 -> 5π/8 radians   X5
    % 0101 -> 3π/4 radians   X6
    % 0100 -> 7π/8 radians   X7
    % 1010 -> π radians      X8
    % 1011 -> 9π/8 radians   X9
    % 1001 -> 5π/4 radians   X10
    % 1000 -> 11π/8 radians  X11
    % 1100 -> 3π/2 radians   X12
    % 1101 -> 13π/8 radians  X13
    % 1111 -> 7π/4 radians   X14
    % 1110 -> 15π/8 radians  X15


    for i = 1:4:length(bit_seq)
        bits = bit_seq(i:i+3);

        if bits(1) == 0
            if bits(2) == 0
                if bits(3) == 0
                    if bits(4) == 0
                        % 0000 => X0
                        X(:, (i+3)/4) = [cos(2*pi*0/16); sin(2*pi*0/16)];
                    else
                        % 0001 => X1
                        X(:, (i+3)/4) = [cos(2*pi*1/16); sin(2*pi*1/16)];
                    end
                else
                    if bits(4) == 1
                        % 0011 => X2
                        X(:, (i+3)/4) = [cos(2*pi*2/16); sin(2*pi*2/16)];
                    else
                        % 0010 => X3
                        X(:, (i+3)/4) = [cos(2*pi*3/16); sin(2*pi*3/16)];
                    end
                end
            else %bit2=1
                if bits(3) == 1
                    if bits(4) == 0
                        % 0110 => X4
                        X(:, (i+3)/4) = [cos(2*pi*4/16); sin(2*pi*4/16)];
                    else
                        % 0111 => X5
                        X(:, (i+3)/4) = [cos(2*pi*5/16); sin(2*pi*5/16)];
                    end
                else
                    if bits(4) == 1
                        % 0101 => X6
                        X(:, (i+3)/4) = [cos(2*pi*6/16); sin(2*pi*6/16)];
                    else
                        % 0100 => X7
                        X(:, (i+3)/4) = [cos(2*pi*7/16); sin(2*pi*7/16)];
                    end
                end
            end
        else %bit1 = 1
            if bits(2) == 1
                if bits(3) == 0
                    if bits(4) == 0
                        % 1100 => X12
                        X(:, (i+3)/4) = [cos(2*pi*12/16); sin(2*pi*12/16)];
                    else
                        % 1101 => X13
                        X(:, (i+3)/4) = [cos(2*pi*13/16); sin(2*pi*13/16)];
                    end
                else %bit3 = 1
                    if bits(4) == 0
                        % 1110 => X15
                        X(:, (i+3)/4) = [cos(2*pi*15/16); sin(2*pi*15/16)];
                    else
                        % 1111 => X14
                        X(:, (i+3)/4) = [cos(2*pi*14/16); sin(2*pi*14/16)];
                    end
                end
            else %bit 2 = 0
                if bits(3) == 0
                    if bits(4) == 0
                        % 1000 => X11
                        X(:, (i+3)/4) = [cos(2*pi*11/16); sin(2*pi*11/16)];
                    else
                        % 1001 => X10
                        X(:, (i+3)/4) = [cos(2*pi*10/16); sin(2*pi*10/16)];
                    end
                else %bit 3 = 1
                    if bits(4) == 0
                        % 1010 => X8
                        X(:, (i+3)/4) = [cos(2*pi*8/16); sin(2*pi*8/16)];
                    else
                        % 1011 => X9
                        X(:, (i+3)/4) = [cos(2*pi*9/16); sin(2*pi*9/16)];
                    end
                end
            end
        end
    end
end


