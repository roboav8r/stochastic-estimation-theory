function [xhist,zhist] = mcltisim(F,Gamma,H,Q,R,xbar0,P0,kmax) 

%H,Q,R,xbar0,P0,kmax
% ltisim : Monte-Carlo simulation of a linear time invariant system.
% 
% 
% Performs a truth-model Monte-Carlo simulation for the discrete-time
% stochastic system model:
% 
% x(k+1) = F*x(k) + Gamma*v(k) 
% z(k) = H*x(k) + w(k)
% 
% Where v(k) and w(k) are uncorrelated, zero-mean, white-noise Gaussian
% random processes with covariances E[v(k)*v(k)�] = Q and E[w(k)*w(k)�] =
% R. The simulation starts from an initial x(0) that is drawn from a
% Gaussian distribution with mean xbar0 and covariance P0. The simulation
% starts at time k = 0 and runs until time k = kmax.
% 
% 
% INPUTS
% 
% F ----------- nx-by-nx state transition matrix
% 
% Gamma ------- nx-by-nv process noise gain matrix
% 
% H ----------- nz-by-nx measurement sensitivity matrix
% 
% Q ----------- nv-by-nv symmetric positive definite process noise
% covariance matrix.
% 
% R ----------- nz-by-nz symmetric positive definite measurement noise
% covariance matrix.
% 
% xbar0 ------- nx-by-1 mean of probability distribution for initial state
% 
% P0 ---------- nx-by-nx symmetric positive definite covariance matrix
% associated with the probability distribution of the initial state.
% 
% kmax -------- Maximum discrete-time index of the simulation
% 
% 
% OUTPUTS
% 
% xhist ------- (kmax+1)-by-nx matrix whose kth row is equal to x(k-1)�.
% Thus, xhist = [x(0), x(1), ..., x(kmax)]�.
% 
% zhist ------- kmax-by-nz matrix whose kth row is equal to z(k)�. Thus,
% zhist = [z(1), z(2), ..., z(kmax)]. Note that the state vector
% xhist(k+1,:)� and the measurement vector zhist(k,:)� correspond to the
% same time. %
%+------------------------------------------------------------------------------+
% References:
% 
% 
% Author:
%+==============================================================================

% Get lengths of x and z
nx = length(xbar0);
nz = length(R);

% Get magnitude of noise
v_mag = chol(Q);
w_mag = chol(R);

% Create random vectors of process and measurement noise
v = v_mag.*randn(kmax,1);
w = w_mag.*randn(kmax,1);

% Initialize x
xhist(1,:) = (xbar0);

% Populate remaining x and z values
for ii=1:kmax
    xhist(ii+1,:) = (F*xhist(ii,:)' + Gamma*v(ii))';
    zhist(ii,:) = (H*xhist(ii+1,:)' + w(ii))';
end