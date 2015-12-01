function [D,X] = cksvd(Y,D,iter,sparsity)
%% Centralized KSVD
% Y - signal 
% n - column length of dictionary, n <= k
% Objective: Given a signal/training set Y, 
%            find best the dictionary to represent Y with sparse coding (X)

[m,k] = size(Y);        % obtain dimensions of Y
a = size(D,1);

if(m ~= a)
   error('Dictionary and Signal are not in the same dimension');
end


for zz=1:iter
    
    D = normc(D);
    X = full(OMP(D,Y,sparsity));
    
    for i=1:m       % codebook update stage

        [num,Ind] = l0norm(X(i,:)',0);          % # of non-zero elements
        
        if( num ~= 0 ) 
            Omega = zeros(k,num);           % matrix to diminish the row vector

            for j=1:length(Ind)             % fill in necessary 1's
                Omega(Ind(j),j) = 1;
            end
                
            P = zeros(m,k);                 % init matrix to keep running sum

            for j=1:m
                if(i ~= j)
                    P = P + D(:,j)*X(j,:);  % add 
                end
            end

            E = Y - P;                      % error (excluding current atom)
            E_R = E*Omega;                  % shrink the error

            [U,S,V] = svd(E_R);

            D(:,i) = U(:,1);

            X(i,Ind) = S(1,1)*(V(:,1)');
        end
       

    end

   
    
end



