%% Reachability analysis of Test #2
% clc;clear;close all;
%% --- Setup scenarios ---

init_dyn = [6.23712614805748e-13,10186.0000000000,1.57079632679490,1.21240033115588e-12,-23936.0000000000,1.57079632679490,34121.9999999999,-3.14159265358979,0]; % Test point 2

% Number of test points
m = size(init_dyn,1);
tf = 44;
st = 1; % Initial advisory
%% Simulate all
% delete(gcp('nocreate')); % End previous parallel session
% [~, cores] = evalc('feature(''numcores'')');
uncc = [5000; 200]; % Original (Let's see which cases are the fastest)
% Compute initial set
Npx = 50; % Number of partitions
Npy = 2; % Number of partitions
% small_sets = init_set.partition([1,2],[Np,1]);
small_sets = compute_set_partitions(init_dyn, uncc(1), uncc(2), Npx, Npy);
Np = length(small_sets);
% output = struct('data',cell(1,Np),'tT',cell(1,Np));
% parpool(cores);
for K = 1 : Np
    try
        IS = small_sets(K);
        t1 = tic;
        output = reach_TestPointsb(IS,@dyns_tp2,st,tf,'approx-star',463,900);
        time = toc(t1);
        save("../data_reach/testpoint2/jat_" + string(K) + ".mat",'output','IS','time','-v7.3');
    catch
        disp("Partition " +string(K) + " of test case 1 failed")
    end
end

% save('../data_reach/testPoints_jat_1.mat','output','-v7.3');
