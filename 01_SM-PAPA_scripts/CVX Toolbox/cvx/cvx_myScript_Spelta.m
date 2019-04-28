%cvx_setup      % reuired for performing the calculations!
%cvx_startup


m = 16; n = 8;
A = randn(m,n);
b = randn(m,1);

cvx_begin
    
    % --------------------------
    % -- Variable Definition ---
    variable x(n)
    %variables x1(1) x2(1) %x(n)   % it returns results in variable x
    % --------------------------
    % -- Optimal Function ------
    %minimize( norm(A*x - b) )
    minimize(x1^2 + x2^2)
    % --------------------------
    % -- Constraints -----------
    subject to
        %C*x == d;
        norm(x, Inf) <= 1;
cvx_end