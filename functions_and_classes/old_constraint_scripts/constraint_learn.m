%% import data for training
if true
    file_name = 'data/agent_20_07_128_512_5obs_m100.mat';
    training_cnstr_data = open(file_name).data;
    rng_loaded = open(file_name).rng_state;
end
%% prefix
prefix = 'july20_mult_100_';
min_t = -multiplier;
max_t = multiplier;
%% setting the seed
if true
    rng(rng_loaded)
end
%% preparing data for constraint function approximator training
if true
    % Extract the input and output data.
    % states_t - input
%     inputData = data_arr(to_one_data_struct(training_cnstr_data,{'velocity_x','velocity_y','velocity_z', ...
%         'vel_proj_x','vel_proj_y','vel_proj_z','rb1x','rb2x','rb3x', ...
%         'rb1y','rb2y','rb3y','rb1z','rb2z','rb3z','c','ekin'}));
    inputData = data_arr(to_one_data_struct(training_cnstr_data,{...
        'velocity_x','velocity_y','velocity_z','c'}));
    % cnstr_t+1 - cnstr_t
    outputData_mltp = data_arr(to_one_data_struct(training_cnstr_data,{'c_next'})) ...
                 - data_arr(to_one_data_struct(training_cnstr_data,{'c'}));
    outputData_1 = outputData_mltp./data_arr(to_one_data_struct(training_cnstr_data,{'u1'}))/max_t;
    outputData_2 = outputData_mltp./data_arr(to_one_data_struct(training_cnstr_data,{'u2'}))/max_t;
    outputData_3 = outputData_mltp./data_arr(to_one_data_struct(training_cnstr_data,{'u3'}))/max_t;
    outputData = [outputData_1 outputData_2 outputData_3];
    % (cnstr_t+1 - cnstr_t )/action - output
    newData = [inputData,outputData];
    
    % Get validation ratio
    validationRatio = 0.1;
    
    % Preprocess data.
    numObs = size(inputData,2);
    numActs = 3;
    actionIndex = (numObs+1):(numObs+3);%size(data,2); % wtf is dis
    stateIndex = 1:numObs;
    
    % Calculate number of validation rows.
    totalRows = size(newData,1);                                   % all verses
    numValidationDataRows = floor(validationRatio*totalRows);   % number of validation verses
    
end
%% network
import java.time.ZonedDateTime;

prefix_ = prefix;

tic
each_network_number = 20;
batch_vec = [256];
alg_vec = ["adam"];
network_structure = {[...
                imageInputLayer([numObs 1 1],'Name','InputLayer','Normalization','rescale-symmetric')...
                fullyConnectedLayer(10,'Name','Fc1'), reluLayer('Name','Relu1')...
                fullyConnectedLayer(3,'Name','OutputLayer'),regressionLayer('Name','RegressionOutput')...
                ]};

for batch_iter = batch_vec
    for alg_iter = alg_vec
        which_struct = 1;
        for structure_iter = 1 : length(network_structure)

            compound_name = [prefix_ 'net_' char(string(alg_iter)) '_' char(string(batch_iter)) '_' char(string(which_struct))];
    
            eval([compound_name '={struct("TrainingLoss",double.empty, ' ...
                    '"TrainingRMSE",double.empty, "ValidationLoss", double.empty, "ValidationRMSE", double.empty,' ...
                    '"BaseLearnRate",double.empty,"FinalValidationRate", double.empty, "FinalValidationRMSE",double.empty,' ...
                    '"OutputNetworkIteration", double.empty)};'] )
            eval([compound_name '_nets = DAGNetwork.empty;']);
            
            for i = 1 : each_network_number
    
                 % Create validation and training data.
                randomIdx = randperm(totalRows,numValidationDataRows);      % index range for validetion verses
                newValidationData= newData(randomIdx,:);
                
                % Calculate training data.
                trainDataIdx = setdiff(1:totalRows,randomIdx);              % indexes not used for validation
                newTrainData = newData(trainDataIdx,:);                        
                numTrainDataRows = size(newTrainData,1);
                
                % reshape train and validation set into 4D arrays, because reasons
                trainInput = reshape(newTrainData(:,stateIndex)',[numObs 1 1 numTrainDataRows]);
                trainOutput = reshape(newTrainData(:,actionIndex)',[1 1 numActs numTrainDataRows]);
                trainData = {trainInput, trainOutput};
                
                newValidationInput = reshape(newValidationData(:,stateIndex)',[numObs 1 1 numValidationDataRows]);
                newValidationOutput = reshape(newValidationData(:,actionIndex)',[1 1 numActs numValidationDataRows]);
                validationData = {newValidationInput, newValidationOutput};
            
                % Create a deep neural network.
    
                % as in example in Matlab documentation
                % https://www.mathworks.com/help/slcontrol/ug/train-reinforcement-learning-agent-with-constraint-enforcement.html
                    
                constraint_network = network_structure{structure_iter};
                options = trainingOptions(alg_iter, ...
                    'Verbose',false, ...
                    'Plots','none', ...
                    'Shuffle','every-epoch', ...
                    'MaxEpochs',25, ...
                    'MiniBatchSize',batch_iter, ...
                    'ValidationData',validationData, ...
                    'InitialLearnRate',0.001, ...
                    'ExecutionEnvironment','auto', ...
                    'GradientThreshold',10);
    
                % training
                % new seed every time
                %rng(randi(1000))
                [trained_constraint_network, train_info] = trainNetwork(trainData{1},trainData{2},constraint_network,options);
                eval([compound_name  '{end+1} = train_info;']);
                eval([compound_name '_nets{end+1} = trained_constraint_network;']);
                disp(['Trained ' compound_name ' nr ' char(string(i)) ] );
                
            end

        eval([compound_name '_options = options;']);
        eval([compound_name '_network_structure = constraint_network;']);
        
        which_struct = which_struct + 1;

        end
    end
end
it_took = toc
%%
constraint_learnt_eval