f = open("libieeep1788_tests_elem.jl")
code_lines = readlines(f)

A = []

chunk_begin = 0
chunk_end = 0

for i in 1:length(code_lines)

  if startswith(code_lines[i], "facts")

    chunk_begin = i

  elseif startswith(code_lines[i], "end")

    chunk_end = i

  end

  if chunk_end - chunk_begin > 100

    push!(A, [chunk_begin, chunk_end])
    chunk_end = 0

  end

end

#for i in length(A)

  insert!(code_lines, A[1][1], "BEGIN")
  #insert!(code_lines, A[i][1] + 50, "")
  #insert!(code_lines, A[i][1] + 50, "end")

#end

for j in A[1][1]-1:A[1][1]+1

  println(code_lines[j])

end

println(A)
