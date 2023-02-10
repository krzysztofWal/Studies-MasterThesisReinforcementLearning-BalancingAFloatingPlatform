% used when using constraint networks, not utilized in final versions of
% simulations

global char_in_
global number_

eval(['network=' char_in_ '_nets{1,' char(string(number_)) '};'])
eval(['net_info =' char_in_ '{1,' char(string(number_+1)) '};' ])
disp("network is no " + string(number_) + " from " + string(char_in_) + ...
       "_nets" ) 
eval(['finalNetLoss =' char_in_ '{1,' char(string(number_+1)) '}.FinalValidationLoss;' ])
eval(['finalNetRMSE =' char_in_ '{1,' char(string(number_+1)) '}.FinalValidationRMSE;' ])
network_name = char_in_;
network_index = number_;
save './data/temp/trainedNetworkG.mat' network -mat
save './data/temp/trainedNetworkG.mat' network_name -mat -append
save './data/temp/trainedNetworkG.mat' network_index -mat -append
save './data/temp/trainedNetworkG.mat' finalNetLoss -mat -append
save './data/temp/trainedNetworkG.mat' finalNetRMSE -mat -append
net_info

% choose_network('may27_w_s_multiplied_10_net_adam_256_1',7);choose_network_script