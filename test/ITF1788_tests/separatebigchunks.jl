#Some numbers have been modified for doing faster tests...

f = open("libieeep1788_tests_elem.jl")
code_lines = readlines(f)[1:158] #Shorter array for tests
code_lines_new = []
#A = []

aux_index = 1 #this number helps appending the 'good' blocks
chunk_begin = 0
chunk_end = 0

for i in 1:length(code_lines)

  if startswith(code_lines[i], "facts")

    chunk_begin = i

  elseif startswith(code_lines[i], "end")

    chunk_end = i

  end

  if chunk_end - chunk_begin > 20 #detecting big blocks of code

    chunk_length = chunk_end - chunk_begin

    append!(code_lines_new, code_lines[aux_index:chunk_begin - 1])

    ## Extract block name: facts("block_name") do

    b = search(code_lines[chunk_begin], "\") do")[1] - 1
    a = search(code_lines[chunk_begin], "facts(\"")[end] +1
    title = code_lines[chunk_begin][a:b]
    number = 1

    # Divide big chunks in blocks of 50 lines

      for j in 0:floor(Int, chunk_length/10) - 1

        push!(code_lines_new, "facts(\"$title" * "_" * "$number\") do")

        append!(code_lines_new, code_lines[chunk_begin + 1 + j*10  : chunk_begin + 1 + (j + 1)*10])

        push!(code_lines_new, "", "end")
        number += 1
      end

    #

    aux_index = chunk_end + 1
    chunk_end = 0

  end

end

new_file = join(code_lines_new, "\n")
f_new = open("test_file.jl", "w")
print(f_new, new_file)
close(f_new)
