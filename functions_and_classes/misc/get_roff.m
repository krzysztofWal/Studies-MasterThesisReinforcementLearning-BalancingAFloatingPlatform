res = read_from_txt('data/wrapped_sim_out/sim_data_data_7_09_roff_random_largerroff_256_take_2.txt', 100, 22, 100, 22)

r_COM = zeros(100,3);
for i = 1 : 100
   r_COM(i,:) = res(i).r_COM(1,:);
end