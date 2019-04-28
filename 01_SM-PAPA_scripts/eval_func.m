function [ y_opt, y_grad_opt ] = eval_func(gamma, error, S_D )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    auxVec = (gamma-error);
    
    y_opt = auxVec'*S_D*auxVec;
    
    y_grad_opt = 2*S_D*auxVec;

end

