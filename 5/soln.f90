function trim(line) result(trimmed)
    implicit none

    CHARACTER(len=*), intent(in) :: line
    CHARACTER, ALLOCATABLE :: trimmed(:)
    INTEGER :: strlen

    strlen = LEN(line)
    do while (line(strlen:strlen) == ' ')
        strlen = strlen - 1
    end do

    allocate(trimmed(strlen))

    trimmed = line(1:strlen)
end function trim

program hello
    implicit none

    type almanac_range
        INTEGER :: start
        INTEGER :: end
        INTEGER :: length
    end type

    type almanac_map(n)
        INTEGER, len :: n
        CHARACTER(len=128) :: source, destination
        type(almanac_range) :: ranges(n)
    end type

    type almanac(num_seeds, num_maps)
        INTEGER :: seeds(num_seeds)
        INTEGER, len :: num_seeds, num_maps
        type(almanac_map) :: maps(num_maps)
    end type

    INTEGER :: i, n, io, ios
    INTEGER, PARAMETER :: read_unit = 99
    CHARACTER(len=128), ALLOCATABLE :: lines(:)
    CHARACTER(len=128) :: buffer
    CHARACTER(len=32) :: arg

    call getarg(1, arg)
    open(read_unit, file=arg, status='old', action='read', iostat=ios)
    if (ios/= 0) stop "Error opening input"

    n = 0
    do
        read(read_unit, '(A)', iostat=ios) buffer
        if (ios/= 0) exit
        n = n + 1
    end do

    allocate(lines(n))
    rewind(read_unit)
    do i = 1, n
        read(read_unit, '(A)') lines(i)
    end do
    close(read_unit)

    do i = 1, n
        print *, trim(lines(i))
    end do
end program hello
