function [smoothedEstimates] = KalmanFilterX_SmoothRTS(filteredEstimates,interval)
%KALMANFILTERX_SMOOTHRTS Perform Rauch�Tung�Striebel KF Smoothing
%
%INPUTS:    filteredEstimates   A (1 x N) array of structures with fields:
%                                   - x   The state estimate for each time-step
%                                   - P   The state covariance for each time-step
%                                   - F   The state transition matrix for
%                                         each time-step
%           iterval             An optional interval (< N) over which to
%                               perform smoothing
%
%OUTPUTS:   smoothedEstimates   A (1 x N) array of structures with fields:
%                                   - x   The state estimate for each time-step
%                                   - P   The state covariance for each time-step
%                                   - F   The state transition matrix for
%                                         each time-step
%                                   - C   The smoothing gain for each
%                                         time-step
%
%October 2017 Lyudmil Vladimirov, University of Liverpool.

    if(nargin==2)
        if(size(interval)>length(filteredEstimates)-1)
            error("Smoothing interval cannot be longer than length(filteredEstimates)-1");
        end
    else
        interval = length(filteredEstimates)-1;
    end

    % Allocate memory
    N                          = length(filteredEstimates);
    smoothedEstimates          = cell(1,N);
    smoothedEstimates{N}       = filteredEstimates{N}; 

    % Perform Rauch�Tung�Striebel Backward Recursion
    for k = N-1:-1:N-interval
        smoothedEstimates{k}       = filteredEstimates{k};
        smoothedEstimates{k}.C     = filteredEstimates{k}.P * filteredEstimates{k+1}.F' / filteredEstimates{k+1}.PPred;
        smoothedEstimates{k}.x     = filteredEstimates{k}.x + smoothedEstimates{k}.C * (smoothedEstimates{k+1}.x - filteredEstimates{k+1}.xPred);
        smoothedEstimates{k}.P     = filteredEstimates{k}.P + smoothedEstimates{k}.C * (smoothedEstimates{k+1}.P - filteredEstimates{k+1}.PPred) * smoothedEstimates{k}.C';                            
    end
end