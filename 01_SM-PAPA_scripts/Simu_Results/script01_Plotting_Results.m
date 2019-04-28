% ======================================================================= %
% == COPPE/UFRJ - Programa de Engenharia Eletrica (PEE) ================= %
% == Script: script01_Plotting_Results ================================== %
% == Responsible: Marcelo Jorge Mendes Spelta - Date: 2019/03/26 ======== %
% == E-mail: marcelo.spelta@smt.ufrj.br ================================= %
% ======================================================================= %

clc; clear;

%% ===================================================================== %%
% ======================================================================= %
% == Loading data obtained from the simulations with the AR1 scenario === %

load('ar1_SC-CV_signals')
cost_ar1_vector(1,:) = cost_vector_db;
error_ar1_vector(1,:) = err_vector_db;
interval_ar1_vector(1,:) = interval_vector_db;
update_ar1_vector(1,:) = vector_number_updates;

load('ar1_Opt-CVX_signals')
cost_ar1_vector(2,:) = cost_vector_db;
error_ar1_vector(2,:) = err_vector_db;
interval_ar1_vector(2,:) = interval_vector_db;
update_ar1_vector(2,:) = vector_number_updates;

load('ar1_Opt-GP_signals')
cost_ar1_vector(3,:) = cost_vector_db;
error_ar1_vector(3,:) = err_vector_db;
interval_ar1_vector(3,:) = interval_vector_db;
update_ar1_vector(3,:) = vector_number_updates;

%% ===================================================================== %%
% ======================================================================= %
% == Plotting results for the AR1 scenario ============================== %

figure
t = 1:(length( cost_ar1_vector(1,:) ));
subplot(1,2,1)
plot(t,cost_ar1_vector(1,:),t,cost_ar1_vector(2,:)) 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize',18)
ylabel('$C(\gamma)$ [dB]','Interpreter','latex','FontSize', 18)
leg1 = legend('SC-CV','GP-CV');
set(leg1,'Interpreter','latex','FontSize',16);
axis([0 4000 -45 35])

subplot(1,2,2)
plot(t,error_ar1_vector(1,:),t,error_ar1_vector(3,:)) 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize',18,'FontName','Times New Roman')
ylabel('MSE [dB]','Interpreter','latex','FontSize',18,'FontName','Times New Roman')
leg1 = legend('SC-CV','GP-CV');
set(leg1,'Interpreter','latex','FontSize',16,'FontName','Times New Roman');
axis([0 4000 -35 30])


%% ===================================================================== %%
% ======================================================================= %
% == Adjusting figure format - AR1 scenario ============================= %

figProp = struct('size',22,'font','Times','lineWidth',2,'figDim',[1 1 900 350]);
figFileName = '../Figures/SM-PAPA_Cost_MSE_AR1';
formatFig(gcf,figFileName,'en',figProp);

%% ===================================================================== %%
% ======================================================================= %
% == Loading data obtained from the simulations with the AR4 scenario === %

load('ar4_SC-CV_signals')
cost_ar4_vector(1,:) = cost_vector_db;
error_ar4_vector(1,:) = err_vector_db;
interval_ar4_vector(1,:) = interval_vector_db;
update_ar4_vector(1,:) = vector_number_updates;

load('ar4_Opt-CVX_signals')
cost_ar4_vector(2,:) = cost_vector_db;
error_ar4_vector(2,:) = err_vector_db;
interval_ar4_vector(2,:) = interval_vector_db;
update_ar4_vector(2,:) = vector_number_updates;

load('ar4_Opt-GP_signals')
cost_ar4_vector(3,:) = cost_vector_db;
error_ar4_vector(3,:) = err_vector_db;
interval_ar4_vector(3,:) = interval_vector_db;
update_ar4_vector(3,:) = vector_number_updates;

%% ===================================================================== %%
% ======================================================================= %
% == Plotting results for the AR4 scenario ============================== %

figure
t = 1:(length( cost_ar4_vector(1,:) ));
subplot(1,2,1)
plot(t,cost_ar4_vector(1,:),t,cost_ar4_vector(2,:)) 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize', 18)
ylabel('$C(\gamma)$ [dB]','Interpreter','latex','FontSize', 18)
leg1 = legend('SC-CV','GP-CV');
set(leg1,'Interpreter','latex','FontSize', 20);
axis([0 4000 -50 35])

subplot(1,2,2)
plot(t,error_ar4_vector(1,:),t,error_ar4_vector(3,:)) 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize',18)
ylabel('MSE [dB]','Interpreter','latex','FontSize',18)
leg1 = legend('SC-CV','GP-CV');
set(leg1,'Interpreter','latex','FontSize',20);
axis([0 4000 -35 30])

%% ===================================================================== %%
% ======================================================================= %
% == Adjusting figure format - AR4 scenario ============================= %

figProp = struct('size',22,'font','Times','lineWidth',2,'figDim',[1 1 900 350]);
figFileName = '../Figures/SM-PAPA_Cost_MSE_AR4';
formatFig(gcf,figFileName,'en',figProp);

%% ===================================================================== %%
% ======================================================================= %
% == Plotting Algorithm Time Interval/Iteration for both simulation ===== %
% == scenarios (AR1 and AR4 inputs) ===================================== % 

figure
subplot(1,2,1)
plot(t,interval_ar1_vector(2,:),'r',t,interval_ar1_vector(3,:),'k',...
    t,interval_ar1_vector(1,:),'b') 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize',18)
ylabel('Time Interval/Iteration [dB]','Interpreter','latex','FontSize',18)
leg1 = legend('CVX','GP','SC');
set(leg1,'Interpreter','latex','FontSize',16);

subplot(1,2,2)
plot(t,interval_ar4_vector(2,:),'r',t,interval_ar4_vector(3,:),'k',...
    t,interval_ar4_vector(1,:),'b') 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize',18)
ylabel('Time Interval/Iteration [dB]','Interpreter','latex','FontSize',18)
leg1 = legend('CVX','GP','SC');
set(leg1,'Interpreter','latex','FontSize',16);

figure
plot(t,interval_ar4_vector(2,:),'r',t,interval_ar4_vector(3,:),'k',...
    t,interval_ar4_vector(1,:),'b') 
grid on
xlabel('Iteration Index','Interpreter','latex','FontSize',18)
ylabel('Time Interval/Iteration [dB]','Interpreter','latex','FontSize',18)
leg1 = legend('CVX','GP','SC');
set(leg1,'Interpreter','latex','FontSize',16);

% == END OF SCRIPT ====================================================== %
% ======================================================================= %