from itertools import combinations

import numpy as np


def read_input():
    lines = []
    with open("input.txt", "r") as file:
        lines = file.readlines()

    return lines


def get_matrix(lines):
    mat = np.zeros((len(lines), len(lines[0]) - 1))
    for i, line in enumerate(lines):
        mat[i] = [char == "#" for char in line.strip()]

    return mat


def print_total(nodes):
    total = sum(
        [np.linalg.norm(comb[0] - comb[1], 1) for comb in combinations(nodes, 2)]
    )
    print(total)


def solve(lines, n=1):
    mat = get_matrix(lines)

    empty_h = mat.sum(axis=0) == 0
    empty_v = mat.sum(axis=1) == 0

    nodes = []

    i = 0
    for row in range(mat.shape[0]):
        if empty_v[row]:
            i += n

        j = 0
        for col in range(mat.shape[1]):
            if empty_h[col]:
                j += n
            if mat[row, col]:
                nodes.append((i, j))
            j += 1
        i += 1

    nodes = np.array(nodes)
    print_total(nodes)


if __name__ == "__main__":
    lines = read_input()
    solve(lines)
    solve(lines, 1000000 - 1)

