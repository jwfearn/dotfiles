#!/usr/bin/env sh
printf '\e[31mRED\e[0m (printf)\n'
CMD='printf "\e[31mRED\e[0m (printf)\n"'
echo "${CMD} => $(${CMD})"
