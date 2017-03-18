
f = open("libieeep1788_tests_elem.jl")
code_lines = readlines(f) #Creates array with all the code lines
code_lines_new = [] #The new array

n_bs = 30 #new blocks size

aux_index = 1 #number that helps appending the 'good' blocks
chunk_begin = 0 #indicates where the big chunk begins
chunk_end = 0 #where the big chunk end

for i in 1:length(code_lines)

  if startswith(code_lines[i], "facts")

    chunk_begin = i

  elseif startswith(code_lines[i], "end")

    chunk_end = i

  end

  if chunk_end - chunk_begin > 100 #detecting big blocks of code

    chunk_length = chunk_end - chunk_begin

    #Appending the blocks that have the good size

    append!(code_lines_new, code_lines[aux_index:chunk_begin - 1])

    ## Extract block name: facts("block_name") do

    b = search(code_lines[chunk_begin], "\") do")[1] - 1
    a = search(code_lines[chunk_begin], "facts(\"")[end] +1
    title = code_lines[chunk_begin][a:b]
    number = 1

    # Divide big chunks in smaller blocks

    residue = chunk_length%n_bs

      for j in 0:floor(Int, chunk_length / n_bs) - 1

        push!(code_lines_new, "facts(\"$title" * "_" * "$number\") do", "\n")

        append!(code_lines_new, code_lines[chunk_begin + 1 + j*n_bs  : chunk_begin + (j + 1)*n_bs])

        push!(code_lines_new, "end", "\n", "\n")

        number += 1

      end

      if residue > 0

        push!(code_lines_new, "facts(\"$title" * "_" * "$number\") do", "\n")

        append!(code_lines_new, code_lines[chunk_end - residue + 1 : chunk_end - 1])

        push!(code_lines_new, "end", "\n")

      end

    aux_index = chunk_end + 1
    chunk_end = 0

  end

end

#writing the new file

new_file = join(code_lines_new)
f_new = open("test_file.jl", "w")
print(f_new, new_file)
close(f_new)
