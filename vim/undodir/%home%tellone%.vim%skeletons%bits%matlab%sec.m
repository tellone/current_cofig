Vim�UnDo� ���(B�J����I�ǌ�;.�H�$	��hD |�                                            O/��    _�                             ����                                                                                                                                                                                                                                                                                                                                                  v        O/�!     �             �                   5�_�                            ����                                                                                                                                                                                                                                                                                                                                                 v        O/�%     �               #beta_step = 0.01;%step size of beta5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  v        O/�4     �               #beta_step = 0.01;%step size of beta   *beta_start = 0.0001;%start value to avoid    delta = 0.001;       % => Set variables5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  v        O/�<     �               gamma_x = 2*pi*rand(1);   !beta_x = beta_start:beta_step:pi;   de = beta_x;       x1 = x;5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  v        O/�@     �               % => Set variables5�_�                            ����                                                                                                                                                                                                                                                                                                                                       
           V        O/�M     �                x1 = x;   Tay = zeros(length(x));       % => The real script    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        O/�X     �                %Ex 15�_�      	                      ����                                                                                                                                                                                                                                                                                                                                                  v        O/�[     �             �                % => Controll parameters�                    % => Controll parameters5�_�      
           	          ����                                                                                                                                                                                                                                                                                                                                                 v        O/�_     �               %Ex 15�_�   	              
          ����                                                                                                                                                                                                                                                                                                                                                 v        O/�c     �               %=>Ex 15�_�   
                        ����                                                                                                                                                                                                                                                                                                                                                 v        O/�d     �               % =>Ex 15�_�                            ����                                                                                                                                                                                                                                                                                                                                                 v   	    O/�q     �                   for k = 1:length(beta_x)   =    Z_c = SetZ(gamma_x(k), beta_x(k)); %SetZ is defind bellow   2    de(k) = cond(Z_c); %Saves the condition number   end    5�_�                    
        ����                                                                                                                                                                                                                                                                                                                                                 v   	    O/�}     �   	            for k = 1:lenght(x)5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        O/��     �                end5�_�                             ����                                                                                                                                                                                                                                                                                                                                                  V        O/��    �                           �         	                  �      	   
      % EX 3           �      
                     �   	                        �   
                    5��