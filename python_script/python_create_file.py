if __name__ == "__main__":
    
    cp_template = "cp ../__INPUT__ "
    sed_template = "sed -i 's/__INPUT_NAME__/__NEW_VALUE__/g' "
    bare_file_template = "=$(echo __FILE_VAR__ | cut -d'.' -f 1)"
    # run_template = """~/matlab/bin/matlab -nodesktop -nodisplay -r "${FILE_NUMBER_BARE};quit()" """
    run_template = """matlab -nodesktop -nodisplay -r "${FILE_NUMBER_BARE};quit()" """
    
    name = ["test_1","test_2"]
    

    a = len(name)

    parameters = [("AGENTSAVENAME",[""]*a), \
    ("AGENTCREATE",[1, 0]), \
    ("AGENTLOADNAME",["empty_value_", "data_"+name[0]+".mat"]), \
    ("ACTORNETSIZE",[512 ,256]), \
    ("CRITICNETSIZE",[512 ,1024]),\
    ("MAXEPISODES",[2]*a), \
    ("MAXSTEPSPEREP",[100]*a), \
    ("STOPTRAINVALUE",[100000000]*a), \
    ("ENTROPY",[4]*a), \
    ("TARGETUPDATE", [1]*a), \
    ("CRITICUPDATE",[1]*a), \
    ("ACTORUPDATE",[1]*a), \
    ("ACTORRATE",[0.0003]*a), \
    ("CRITICRATE",[0.0003]*a), \
    ("W1",[ 1]*a), \
    ("W2",[ 0.005, 0.01]), \
    ("SAMPLETIME",[0.15]*a), \
    ("__NOTBASH__",["BASH"]*a)
    ]
   
    files_to_copy = []

    # files to copy
    for i in range(0,len(name)):
        files_to_copy.append("RL_menage.m")
    #for i in range(0,5):
    #    files_to_copy.append("RL_menage_SAC_pend.m")
        
        
    for i in range(0,len(name)):
        parameters[0][1][i] = "data_" + name[i] + ".mat" 
        
        
    print("#!/bin/bash")
    for i in range(0, len(name)):
        # create file variables
        print("FILE_" + str(i) + "='file_" + name[i] + ".m'")
    
    print("")
    
    print("cd with_RLscript")

    for i in range(0, len(name)):
        print(cp_template.replace("__INPUT__",files_to_copy[i]) + " $FILE_" + str(i))
    
    print("")
    for j in range(0, len(parameters)):
        for i in range(0,len(name)):
            print(sed_template.replace("__INPUT_NAME__",str(parameters[j][0])).replace("__NEW_VALUE__",str(parameters[j][1][i])) + " $FILE_" + str(i))
        print("")
        
    for i in range(0, len(name)):
        print("FILE_"+str(i) + "_BARE" +bare_file_template.replace("__FILE_VAR__","$FILE_"+str(i)))
    
    print("")
    # for i in range(0, len(name)):
    # #for i in [4,9]:
       # print(run_template.replace("NUMBER",str(i)))
        
    print("")
    print('echo "Operation succesfull"')
    print("cd ..")
    
 
    
