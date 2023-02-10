#!/bin/bash
rm -r ./unz
mkdir unz

unzip 'RL_env.slx' -d ./unz/RL_env_unz
unzip './3D_model/dynamic_model_euler.slx' -d ./unz/dme_unz

cd unz/RL_env_unz
echo "'=====Reward:====="
grep -rn -e 'reward =' | head -n1
echo "'=====Stop condition:====="
grep -rn -e 'srch_flag' | head -n1
cd .. 
cd ..

cd unz/dme_unz
grep  -E -rn -e 'ObservationSelector|Name="OutputSignals"' 

grep  -E -rn -e 'RewardSelector|Name="OutputSignals"' 
cd .. 

cd ..
