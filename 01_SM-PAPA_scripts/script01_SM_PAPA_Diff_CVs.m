% ======================================================================= %
% == COPPE/UFRJ - Programa de Engenharia Eletrica (PEE) ================= %
% == Script: script01_SM_PAPA_Diff_CVs ================================== %
% == Responsible: Marcelo Jorge Mendes Spelta - Date: 2019/03/26 ======== %
% == E-mail: marcelo.spelta@smt.ufrj.br ================================= %
% ======================================================================= %
% Script Description: SM-PAPA Simulation with Selected CV 
% ======================================================================= %
% == ATTENTION: This file requires the installation of CVX. This can be = %
% == done by entering the 'CVX Toolbox' directory and inserting the ===== %
% == 'cvx_setup' command. =============================================== %
% ======================================================================= %

% Problem Description: System with order N = 15, so the filter has 16
% coefficients, these coefficients are given by  the sequence [1 0 1 0 .. 0 ]
% until the time instant K in which they become [2 0 2 0 2 ... 0].

clc;clear;format shortEng;

% ======================================================================= %
% -- Global Parameters -------------------------------------------------- %
numberCoeff = 16;   
N = numberCoeff - 1;
L = 3;      % number of previous values used in this algorithm AP 
numberSamples = 4000;  % Total number of samples for each iteration
K = 1000;  % Transition instant of the reference system

average = 0;
variance_noise = 1e-3;
gamma_bound = sqrt(5*variance_noise);

% ======================================================================= %
% == Coefficients Vector of the system to be identified
w_system_1 = [ 1 0 0 0 1 1 0 0 0 0 0 0 1 1 1 0]';   % sparse system to be identified
w_system_2 = 2*w_system_1;
w_system_coeff = [w_system_1*ones(1,K) w_system_2*ones(1,numberSamples - K) ]; 
% ======================================================================= %

for simulation_setup = [ 1 3 4 6] %1:6 %[3 6] %5:6 %1:6
    % =================================================================== %
    % == Input Signal Selection:
    % -- 1 - AR1 Process / 2 - AR4 Process
    % =================================================================== %
    % == CV Selection:
    % -- 1 - Simple-Choice CV (SC-CV) / 2 - Optimal CV computation with CVX (Interior-points Methods) / 
    % -- 3 - Optimal CV computation with Gradient Projection Method
    % =================================================================== %
    switch (simulation_setup)
        case 1
            inputSignal = 1; selected_CV = 1;  % AR1 with SC-CV
            fileName = 'ar1_SC-CV_signals';
        case 2
            inputSignal = 1; selected_CV = 2;  % AR1 with Opt. CV using CVX (Interior-points method)
            fileName = 'ar1_Opt-CVX_signals';
        case 3
            inputSignal = 1; selected_CV = 3;  % AR1 with Opt. CV using Gradient Projection (GP)
            fileName = 'ar1_Opt-GP_signals';
        case 4
            inputSignal = 2; selected_CV = 1;  % AR1 with SC-CV
            fileName = 'ar4_SC-CV_signals';
        case 5
            inputSignal = 2; selected_CV = 2;  % AR1 with Opt. CV using CVX (Interior-points method)
            fileName = 'ar4_Opt-CVX_signals';
        case 6
            inputSignal = 2; selected_CV = 3;  % AR1 with Opt. CV using Gradient Projection (GP)
            fileName = 'ar4_Opt-GP_signals';
    end
    % =================================================================== %
    
    
    matrix_squared_error_values = [];
    matrix_cost_function_values = [];
    matrix_misalignment_values = [];
    matrix_interval_values = [];
    vector_number_updates = [];

    final_w_vector = zeros(numberCoeff,1);
    gamma_cv = zeros(L+1,1);
    cost_function = 1;

        for iterationCounter = 1:numberRuns
            % ======================================================================= %
            % --------------------------------------------------------------- %
            % -- Generating Random Vector
            ar_input = zeros(1,numberSamples);
            n = randn(numberSamples,1)*sqrt(variance_noise); % noise that appears on the reference signal
            x = zeros(numberSamples,1); % System input
            d = zeros(numberSamples,1); % System output with no noise
            % --------------------------------------------------------------- %

            w = zeros(numberCoeff,1);   % zero initial values (Initial Values)

            error_values = zeros(1,numberCoeff);
            cost_function_values = zeros(1,numberCoeff);
            misalignment_values = zeros(1,numberCoeff);
            interval_values = zeros(1,numberCoeff);
            x_vec_input = zeros(numberCoeff,numberSamples);
            w_values = zeros(numberCoeff,numberCoeff);
            y_values = zeros(1,numberCoeff);

            number_updates = 0;

            for counter=(numberCoeff+2):numberSamples
                % ------------------------------------------------------- %
                % -- Generating Auto-regressive signals ----------------- %
                if (inputSignal == 1)   % AR1
                    ar_input(counter) = 0.95*ar_input(counter-1) + randn(1);
                else                    % AR4
                    ar_input(counter) = 0.95*ar_input(counter-1) + 0.19*ar_input(counter-2) + ...
                end
                % ------------------------------------------------------- %
                x_vec_input(:,counter) = ar_input(counter:-1:(counter - numberCoeff + 1));  % current input vector
                d(counter) = w_system_coeff(:,counter)'*x_vec_input(:,counter) + n(counter); % current reference vector
                X_ap = x_vec_input(:,counter:-1:counter-L);  % Input signal matrix (using L previous input vector) --> numbCoeff x (L+1)
                d_ap = d(counter:-1:counter-L); % Reference signal vector (using L previous values) --> R^{(L+1)}
                % ------------------------------------------------------- %

                % =============================================
                % == It calls the SM-PAPA with differente CV choices
                [ gamma_cv, error, cost_function, next_w, interval] = ...
                    SM_PAPA(d_ap, w , X_ap, gamma_cv, selected_CV, gamma_bound, cost_function);
                % =============================================

                if (interval ~= 0)
                    number_updates = number_updates + 1;
                end

                misalignment = norm(next_w - w_system_coeff(:,counter))/...
                    norm(w_system_coeff(:,counter));

                error_values = [error_values,error];
                cost_function_values = [cost_function_values, cost_function];
                misalignment_values = [misalignment_values, misalignment];
                interval_values = [interval_values, interval];

                w_values = [w_values,next_w];

                w = next_w;
            end

            matrix_squared_error_values = [matrix_squared_error_values; error_values.^2];
            matrix_cost_function_values = [matrix_cost_function_values; cost_function_values];
            matrix_misalignment_values = [matrix_misalignment_values; misalignment_values];
            matrix_interval_values = [matrix_interval_values; interval_values];

            vector_number_updates = [vector_number_updates, number_updates];

            iterationCounter

        end % Iteration Counter end

        for counter=1:3999%length(error_values)
            mean_squared_error_values(counter) = mean(matrix_squared_error_values(:,counter));
            mean_cost_function_values(counter) = mean(matrix_cost_function_values(:,counter));
            mean_misalignment_values(counter) = mean(matrix_misalignment_values(:,counter));
        end

        
    % == Saving data on file
    t = 1:(numberSamples-1);
    err_vector_db = 10*log10(mean_squared_error_values(t));
    cost_vector_db = 10*log10(mean_cost_function_values(t));
    interval_vector_db = 10*log10(mean_interval_values(t));

    save(['./Simu_Results/' fileName],'err_vector_db','cost_vector_db','interval_vector_db','vector_number_updates','numberRuns')
        
end
    
% == END OF SCRIPT ====================================================== %
% ======================================================================= %
% ======================================================================= %