f = open("libieeep1788_tests_elem.jl")
code_lines = readlines(f)

A = Int[]

chunk_begin = 0
chunk_end = 0

for i in 1:length(code_lines)

  if length(code_lines[i]) <= 3

    nothing

  elseif code_lines[i][1:3] == "fac"

    chunk_begin = i

  elseif code_lines[i][1:3] == "end"

    chunk_end = i

  end

  if chunk_end - chunk_begin > 100

    push!(A, chunk_begin)
    chunk_end = 0

  end

end

println(A)
