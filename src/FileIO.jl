module FileIO
import Base: read
import Base: write
import Base: (==)
import Base: open
import Base: abspath
import Base: readbytes
import Base: readall
# package code goes here


immutable File{Ending}
	abspath::UTF8String
end

function File(file)
	@assert isfile(file) "file string doesn't refer to a file. Path: $file"
	file = abspath(file)
	_, ending = splitext(file)
	File{symbol(lowercase(ending[2:end]))}(file)
end
macro file_str(path::AbstractString)
	File(path)
end
File(folders...) = File(joinpath(folders...))
ending{Ending}(::File{Ending}) = Ending
(==)(a::File, b::File) = a.abspath == b.abspath
open(x::File)       = open(abspath(x))
abspath(x::File)    = x.abspath
readbytes(x::File)  = readbytes(abspath(x))
readall(x::File)    = readbytes(abspath(x))

read{Ending}(f::File{Ending}; options...)  = error("no importer defined for file ending $T in path $(f.abspath), with options: $options")
write{Ending}(f::File{Ending}; options...) = error("no exporter defined for file ending $T in path $(f.abspath), with options: $options")


export ending
export File
export @file_str

end # module
