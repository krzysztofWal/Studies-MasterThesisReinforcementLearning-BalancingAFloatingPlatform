function [actorNetGraph, critic1NetGraph, critic2NetGraph] = extract_networks(agentObj, if_three)
% network extraction
    actor = getActor(agentObj);
    actorNet = getModel(actor);
    actorNetGraph = layerGraph(actorNet);
    
    critics = getCritic(agentObj);
    criticNet1 = getModel(critics(1));
    critic1NetGraph = layerGraph(criticNet1);
    
    critic2NetGraph = [];
    if if_three
        criticNet2 = getModel(critics(2));
        critic2NetGraph = layerGraph(criticNet2);
    end
end

