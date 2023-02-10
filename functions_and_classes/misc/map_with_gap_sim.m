function output = map_with_gap_sim(x, in_min, in_max, out_min, out_max)
    output = map_m(x, in_min, in_max, out_min, out_max);
    if map_m(rand(1),0,1,-1,1) > 0
        output = -output;
    end
end