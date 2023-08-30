function get_chemistery_index(batter,sys)
    x_index = Int64[]
    x_map = states(sys)
    for i in 1:length(batter.c_s_neg[:,end])
        for j in 1:length(x_map)
            if isequal(batter.c_s_neg[i,end],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    for i in 1:length(batter.c_s_pos[:,end])
        for j in 1:length(x_map)
            if isequal(batter.c_s_pos[i,end],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    for i in 1:length(batter.c_l_neg)
        for j in 1:length(x_map)
            if isequal(batter.c_l_neg[i],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    for i in 1:length(batter.c_l_pos)
        for j in 1:length(x_map)
            if isequal(batter.c_l_pos[i],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    for i in 1:length(batter.c_l_sep)
        for j in 1:length(x_map)
            if isequal(batter.c_l_sep[i],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    return x_index
end
function get_electric_index(batter,sys)
    x_index = Int64[]
    x_map = states(sys)
    for i in 1:length(batter.U_ct_neg)
        for j in 1:length(x_map)
            if isequal(batter.U_ct_neg[i],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    for i in 1:length(batter.U_ct_pos)
        for j in 1:length(x_map)
            if isequal(batter.U_ct_pos[i],x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    return x_index
end
function get_electric_vi_index(batter,sys)
    x_index = Int64[]
    x_map = states(sys)
        for j in 1:length(x_map)
            if isequal(batter.v,x_map[j])
                push!(x_index,j)
                break
            end
    end
        for j in 1:length(x_map)
            if isequal(batter.i,x_map[j])
                push!(x_index,j)
                break
            end
    end
    return x_index
end