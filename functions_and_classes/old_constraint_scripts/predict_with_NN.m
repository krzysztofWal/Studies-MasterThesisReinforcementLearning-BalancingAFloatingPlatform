function [out] = predict_with_NN(obs)
%PREDICTWITHNN Summary of this function goes here
%   Detailed explanation goes here
%     out = single([0; 0; 0]);
%     disp(['predictWithNN dummy'])

    %#codegen
    out = predict_constraint(obs);


    function temp = predict_constraint(obs)

        persistent policy
        if isempty(policy)
	        policy = coder.loadDeepLearningNetwork('trainedNetworkG.mat','network');
        end
        
        temp = predict(policy, obs);

    end
end

