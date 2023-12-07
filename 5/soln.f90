function count_numbers(text) result(count)
    implicit none

    CHARACTER(len=*), intent(in) :: text
    INTEGER :: count

    INTEGER :: strlen, i
    LOGICAL :: flag = .false.

    count = 0
    strlen = LEN_TRIM(text)
    do i = 1, strlen
        if (text(i:i) .EQ. ' ') then
            count = count + 1
        end if
    end do
end function

program hello
    implicit none

    type almanac_range
        INTEGER(kind=8) :: dst = -1
        INTEGER(kind=8) :: src = -1
        INTEGER(kind=8) :: length = -1
    end type

    type almanac_map
        CHARACTER(len=128) :: source, destination
        INTEGER :: num_ranges = 0
        type(almanac_range), ALLOCATABLE :: ranges(:)
    end type

    INTEGER :: i, j, k, n, num_seeds, num_grps, io, ios, count_numbers, max_range
    INTEGER(kind=8) :: dst, src, length, smallest
    LOGICAL :: grp_flag = .false.
    INTEGER, PARAMETER :: read_unit = 99
    CHARACTER(len=256), ALLOCATABLE :: lines(:)
    CHARACTER(len=256) :: buffer
    CHARACTER(len=32) :: arg
    INTEGER(kind=8), ALLOCATABLE :: seeds(:)
    type(almanac_map), ALLOCATABLE :: maps(:)

    call getarg(1, arg)
    open(read_unit, file=arg, status='old', action='read', iostat=ios)
    if (ios/= 0) stop "Error opening input"

    n = 0
    do
        read(read_unit, '(A)', iostat=ios) buffer
        if (ios/= 0) exit
        n = n + 1
    end do

    num_seeds = 0
    num_grps = 0
    max_range = 0
    j = 0

    allocate(lines(n))
    rewind(read_unit)
    do i = 1, n
        read(read_unit, '(A)') lines(i)
        if (i .EQ. 1) then
            num_seeds = count_numbers(lines(i))
            ALLOCATE(seeds(num_seeds))
            read(lines(i)(7:LEN_TRIM(lines(i))), *) seeds
        else if (lines(i)(LEN_TRIM(lines(i)):LEN_TRIM(lines(i))) .EQ. ':') then
            num_grps = num_grps + 1
            grp_flag = .true.
        else if (grp_flag .AND. LEN_TRIM(lines(i)) .EQ. 0) then
            grp_flag = .false.
            if (j > max_range) then
                max_range = j
            end if
            j = 0
        else if (grp_flag) then
            j = j + 1
        end if
    end do
    close(read_unit)

    ALLOCATE(maps(num_grps)) 
    do i = 1,num_grps
        ALLOCATE(maps(i)%ranges(max_range))
    end do

    j = 0
    do i = 3, n
        print *, trim(lines(i))
        if (lines(i)(LEN_TRIM(lines(i)):LEN_TRIM(lines(i))) .EQ. ':') then
            j = j + 1
            k = 1
            cycle
        else if (LEN_TRIM(lines(i)) .EQ. 0) then
            cycle
        end if

        read(lines(i), *) maps(j)%ranges(k)
        maps(j)%num_ranges = k
        print *, maps(j)%ranges(k)
        k = k + 1
    end do

    do i = 1, num_seeds
        print *, "Start: ", seeds(i)
        do j=1,num_grps
            print *, "Group: ", j
            grp_flag = .true.
            do k=1,maps(j)%num_ranges 
                if (.NOT. grp_flag) then
                    cycle
                end if

                dst = maps(j)%ranges(k)%dst
                src = maps(j)%ranges(k)%src
                length = maps(j)%ranges(k)%length
                print *, "Dest, Src, Len: ", dst, src, length
                if (src .LE. seeds(i) .AND. seeds(i) .LE. (src + length)) then
                    print *, seeds(i) - src + dst
                    seeds(i) = seeds(i) - src + dst
                    grp_flag = .false.
                end if
            end do
        end do
        print *, "End: ", seeds(i)
    end do

    smallest = seeds(1)
    do i = 1, num_seeds
        smallest = MIN(smallest, seeds(i))
    end do
    print *, "Smallest: ", smallest
end program hello
