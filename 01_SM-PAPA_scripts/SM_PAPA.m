% ======================================================================= %
% == COPPE/UFRJ - Programa de Engenharia Eletrica (PEE) ================= %
% == Script: SM_PAPA.m ================================================== %
% == Responsible: Marcelo Jorge Mendes Spelta - Date: 2019/03/26 ======== %
% == E-mail: marcelo.spelta@smt.ufrj.br ================================= %
% ======================================================================= %

function [ gamma_cv, error, cost_function, next_w, interval] = ...
    SM_PAPA(d_ap, w , X_ap, prev_gamma_cv, gamma_cv_selection, gamma_bound, prev_cost_function)

    % =================================================================== %
    % -- Algorithm Parameters ------------------------------------------- %
    kappa = 0.9;    % Internal algorithm parameter for obtaining the proportionate coefficients
    delta = 5*1e-7;  % Small value for preventing numerical instabilities
    [numbLines, numbColumns] = size(X_ap);
    gamma_cv = zeros(numbColumns,1);
    
    % =================================================================== %
    error_ap = d_ap - X_ap'*w;  % The same as the affine projection (without set-membership)
    
    % ==================================================
    % G matrix generation
    
    g = zeros(numbLines,1);
    norm_w = norm(w, 1);
    % ---------------------
    % Find alpha ----------
    if( abs(error_ap(1) ) > gamma_bound )
        alpha = 1 - gamma_bound/abs(error_ap(1));
    else
        alpha = 0;
    end
    % ----------------
    if (norm_w > 0)
        g = (1 - kappa*alpha)/numbLines + (kappa*alpha*abs(w))/norm_w;
    else
        g = (1 - kappa*alpha)/numbLines;
    end
    G = diag(g);    
    
    % ==================================================
    
    if ( abs( error_ap(1) ) > gamma_bound ) 
        % ----------------------------------------
        S_D = inv( X_ap'*G*X_ap + delta*eye(numbColumns) );
        
        switch (gamma_cv_selection)
            % =========================================================== %
            case 1  % Simple-Choice CV
                tic;
                gamma_cv = error_ap;
                gamma_cv(1) = gamma_bound*sign(error_ap(1));
                interval = toc;
            % =========================================================== %
            case 2  % CVX for solving the problem 
                % ------------------------------------------------------- %
                tic
                % ================================
                cvx_begin quiet
                    % --------------------------
                    % -- Variable Definition ---
                    %variable x(n)
                    variables x1 x2 x3 x4 % it returns results in variable x
                    x = [x1;x2;x3;x4];
                    % --------------------------
                    % -- Optimal Function ------
                    minimize( (x - error_ap)'*S_D*(x - error_ap) )
                    % --------------------------
                    % -- Constraints -----------
                    subject to
                        % ----------------------
                        % Equality Constraints
                        % [None]
                        % ----------------------
                        % Inequality Constraints
                          x1 - gamma_bound <= 0;
                          x2 - gamma_bound <= 0;
                         -x1 - gamma_bound <= 0;
                         -x2 - gamma_bound <= 0;
                          x3 - gamma_bound <= 0;
                          x4 - gamma_bound <= 0;
                         -x3 - gamma_bound <= 0;
                         -x4 - gamma_bound <= 0;
                cvx_end
                % ================================
                interval = toc;
                gamma_cv = [x1;x2;x3;x4];
            % =========================================================== %
            case 3  % Gradient Projection for solving the problem
                % ------------------------------------------------------- %
                tic
                gamma_cv = GP_alg(@eval_func, prev_gamma_cv, error_ap, ...
                    S_D, gamma_bound, -gamma_bound, 1e-6, 1000);  
                interval = toc;
           % =========================================================== %
        end
        
        %error_ap;
        %gamma_cv;
        
        next_w = w + G*X_ap*S_D*(error_ap - gamma_cv);        
        cost_function = (error_ap - gamma_cv)'*inv( X_ap'*G*X_ap + delta*eye(numbColumns) )*(error_ap - gamma_cv);

        % ------------------------------------------
    else
        cost_function = prev_cost_function;
        interval = 0;   % no update indication
        next_w = w;
    end

    
    error = error_ap(1);
end

% == END OF SCRIPT ====================================================== %
% ======================================================================= %