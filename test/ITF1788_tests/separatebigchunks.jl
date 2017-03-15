f = open("libieeep1788_tests_elem.jl")
code_lines = readlines(f)
code_lines_new = String[]
A = []

aux_index = 1
block_title{:String}
chunk_begin = 0
chunk_end = 0

for i in 1:length(code_lines)

  if startswith(code_lines[i], "facts")

    chunk_begin = i

  elseif startswith(code_lines[i], "end")

    chunk_end = i

  end

  if chunk_end - chunk_begin > 100

    #append!(code_lines_new, code_lines[aux_index:chunk_begin - 1])

    push!(A, [chunk_begin, chunk_end])
    chunk_end = 0

  end

end

println(typeof(code_lines[33]))
